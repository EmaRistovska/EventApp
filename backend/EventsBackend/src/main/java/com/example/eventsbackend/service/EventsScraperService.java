package com.example.eventsbackend.service;

import com.example.eventsbackend.model.Event;
import org.jsoup.Jsoup;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.http.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class EventsScraperService {

    private List<Event> cachedEvents = new ArrayList<>();

    private final RestTemplate restTemplate = new RestTemplate();

    /* ========================================================= */
    /* ===================== KUPIKARTA API ===================== */
    /* ========================================================= */

    public List<Event> fetchKupikartaEvents() {

        List<Event> events = new ArrayList<>();

        try {

            String baseUrl = "https://kupikarta.com/";
            String apiUrl = "https://kupikarta.com/services/exportdata.asmx/GetGroupedEvents";

            ResponseEntity<String> initial =
                    restTemplate.getForEntity(baseUrl, String.class);

            List<String> cookies = initial.getHeaders().get("Set-Cookie");

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.add("from-angular", "true");
            headers.add("lang", "mk-MK");

            if (cookies != null) {
                headers.put(HttpHeaders.COOKIE, cookies);
            }

            String body = """
             {
                "filter": {
                    "Page": 1,
                    "Size": 200,
                    "MobileEnabled": true
              }
              }
                    """;

            HttpEntity<String> request =
                    new HttpEntity<>(body, headers);

            ResponseEntity<Map> response =
                    restTemplate.exchange(
                            apiUrl,
                            HttpMethod.POST,
                            request,
                            Map.class
                    );

            Map responseBody = response.getBody();

            if (responseBody != null && responseBody.containsKey("d")) {

                List<Map> dList = (List<Map>) responseBody.get("d");

                for (Map parent : dList) {

                    List<Map> groups =
                            (List<Map>) parent.get("EventGroups");

                    for (Map group : groups) {

                        List<Map> evs =
                                (List<Map>) group.get("Events");

                        for (Map ev : evs) {
                            String title = (String) ev.get("NameFirst");
                            String date = (String) ev.get("Date");
                            String image = "https://kupikarta.com/" + ev.get("Image");

                            Integer eventId = (Integer) ev.get("Id");
                            String buyUrl = "https://kupikarta.com/tickets.nspx?eventid=" + eventId;

                            Map objectMap = (Map) ev.get("ObjectMap");
                            String location = "";
                            if (objectMap != null) {
                                location = (String) objectMap.get("NameFirst");
                            }

                            Double priceValue = null;

                            Object priceObj = ev.get("PriceCurrencySecond");
                            if (priceObj instanceof Number) {
                                priceValue = ((Number) priceObj).doubleValue();
                            }

                            String price = "";

                            if (priceValue != null && priceValue > 0) {

                                if (priceValue % 1 == 0) {
                                    price = String.format("%.0f", priceValue) + " МКД";
                                } else {
                                    price = priceValue + " МКД";
                                }
                            }

                            String rawDesc = (String) ev.get("DescriptionSecond");

                            String description = "";

                            if (rawDesc != null) {
                                description = Jsoup.parse(rawDesc).text();
                            }

                            Event event = new Event(
                                    title,
                                    date,
                                    location,
                                    image,
                                    price,
                                    buyUrl,
                                    "Kupikarta",
                                    "concert",
                                    description
                            );

                            events.add(event);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return events;
    }

    /* ========================================================= */
    /* ======================= TICKETX ========================= */
    /* ========================================================= */

    private WebDriver createDriver() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        return new ChromeDriver(options);
    }

    public List<Event> scrapeTicketX() {

        List<Event> events = new ArrayList<>();

        WebDriver driver = createDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        try {

            driver.get("https://ticketx.com.mk/");

            wait.until(ExpectedConditions.presenceOfElementLocated(
                    By.cssSelector("div.py-8")
            ));

            List<WebElement> sections =
                    driver.findElements(By.cssSelector("div.py-8"));

            System.out.println("SECTIONS: " + sections.size());

            for (WebElement section : sections) {

                // ================= GENRE =================
                String sectionTitle = "";

                try {
                    sectionTitle = section.findElement(By.tagName("h1"))
                            .getText()
                            .toLowerCase();
                } catch (Exception ignored) {}

                String genre = "other";

                if (sectionTitle.contains("стенд")) genre = "standup";
                else if (sectionTitle.contains("концерт")) genre = "concert";
                else if (sectionTitle.contains("спорт")) genre = "sport";

                // ================= CARDS =================

                List<WebElement> cards =
                        section.findElements(By.cssSelector("div.sc-dkzDqf"));

                System.out.println("CARDS FOUND: " + cards.size());

                for (WebElement card : cards) {

                    String title = "";
                    String date = "";
                    String location = "";
                    String imageUrl = "";
                    String buyUrl = "";
                    String description = "";
                    String price = "";

                    try {

                        try {
                            title = card.findElement(By.tagName("h3")).getText();
                        } catch (Exception ignored) {}

                        try {
                            imageUrl = card.findElement(By.cssSelector("div.image img"))
                                    .getAttribute("src");
                        } catch (Exception ignored) {}

                        List<WebElement> spans =
                                card.findElements(By.tagName("span"));

                        if (spans.size() > 0)
                            location = spans.get(0).getText();

                        if (spans.size() > 1)
                            date = spans.get(1).getText();

                        // ---------- BUY URL ----------
                        try {
                            buyUrl = card.findElement(By.cssSelector("div.image"))
                                    .getAttribute("href");

                            if (buyUrl != null && !buyUrl.startsWith("http")) {
                                buyUrl = "https://ticketx.com.mk" + buyUrl;
                            }

                        } catch (Exception ignored) {}

                    } catch (Exception ignored) {}

                    // ================= DETAIL PAGE =================

                    if (buyUrl != null && !buyUrl.isEmpty()) {

                        try {

                            ((JavascriptExecutor) driver)
                                    .executeScript("window.open(arguments[0])", buyUrl);

                            List<String> tabs =
                                    new ArrayList<>(driver.getWindowHandles());

                            driver.switchTo().window(tabs.get(1));

                            WebDriverWait waitDetail =
                                    new WebDriverWait(driver, Duration.ofSeconds(10));

                            // -------- DESCRIPTION --------
                            try {

                                waitDetail.until(ExpectedConditions
                                        .presenceOfElementLocated(
                                                By.cssSelector("div.event-description")
                                        ));

                                WebElement descEl =
                                        driver.findElement(By.cssSelector("div.event-description"));

                                description = descEl.getText();

                            } catch (Exception ignored) {}

                            try {

                                List<WebElement> priceElements =
                                        driver.findElements(
                                                By.cssSelector(".price, .event-price")
                                        );

                                for (WebElement p : priceElements) {

                                    String text = p.getText();

                                    if (text.matches(".*\\d+.*")) {

                                        price = text.replaceAll("[^0-9]", "");

                                        if (!price.isEmpty()) {
                                            price = price + " МКД";
                                            break;
                                        }
                                    }
                                }

                            } catch (Exception ignored) {}

                            driver.close();
                            driver.switchTo().window(tabs.get(0));

                        } catch (Exception ignored) {}
                    }

                    // ================= ADD EVENT =================

                    events.add(new Event(
                            title,
                            date,
                            location,
                            imageUrl,
                            price,
                            buyUrl,
                            "TicketX",
                            genre,
                            description
                    ));
                }
            }

        } finally {
            driver.quit();
        }

        return events;
    }

    public List<Event> scrapeMktickets() {

        List<Event> events = new ArrayList<>();

        WebDriver driver = createDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        try {

            driver.get("https://mktickets.mk/en/");
            System.out.println(driver.getPageSource());

            wait.until(
                    ExpectedConditions.presenceOfElementLocated(
                            By.id("events-category")
                    )
            );

            List<WebElement> cards =
                    driver.findElements(
                            By.cssSelector("div.event-cat-single")
                    );

            System.out.println("MKTickets events: " + cards.size());

            for (WebElement card : cards) {

                String title = "";
                String buyUrl = "";
                String imageUrl = "";
                String location = "";
                String date = "";
                String description = "";
                String price = "";

                try {

                    WebElement link = card.findElement(
                            By.cssSelector("h3.entry-title a")
                    );

                    title = link.getText();
                    buyUrl = link.getAttribute("href");

                    imageUrl = card.findElement(
                            By.cssSelector("a.poster-link img")
                    ).getAttribute("src");

                    List<WebElement> spans =
                            card.findElements(By.cssSelector("p span"));

                    if (spans.size() > 0)
                        location = spans.get(0).getText();

                    if (spans.size() > 1)
                        date = spans.get(1).getText();

                    if (spans.size() > 2)
                        date = date + " " + spans.get(2).getText();

                } catch (Exception ignored) {}

                // ================= GENRE =================
                String genre = "other";

                try {

                    List<WebElement> parents =
                            card.findElements(By.xpath("./ancestor::div[contains(@class,'event-category-container')]"));

                    if (!parents.isEmpty()) {

                        String classAttr = parents.get(0).getAttribute("class").toLowerCase();

                        if (classAttr.contains("concert"))
                            genre = "concert";

                        else if (classAttr.contains("festival"))
                            genre = "festival";

                        else if (classAttr.contains("theatre"))
                            genre = "theatre";

                        else if (classAttr.contains("classic"))
                            genre = "classical";

                        else if (classAttr.contains("sport"))
                            genre = "sport";
                    }
                } catch (Exception ignored) {}

                // ================= DETAIL PAGE =================

                if (buyUrl != null && !buyUrl.isEmpty()) {

                    try {

                        ((JavascriptExecutor) driver)
                                .executeScript("window.open(arguments[0])", buyUrl);

                        List<String> tabs =
                                new ArrayList<>(driver.getWindowHandles());

                        driver.switchTo().window(tabs.get(1));

                        WebDriverWait waitDetail =
                                new WebDriverWait(driver, Duration.ofSeconds(10));

                        // DESCRIPTION
                        try {
                            waitDetail.until(
                                    ExpectedConditions.presenceOfElementLocated(
                                            By.cssSelector(".event-content, .entry-content, .description")
                                    )
                            );

                            description =
                                    driver.findElement(
                                            By.cssSelector(".event-content, .entry-content, .description")
                                    ).getText();

                        } catch (Exception ignored) {}

                        try {

                            List<WebElement> priceElements =
                                    driver.findElements(By.xpath("//*[contains(text(),'MKD')]"));

                            for (WebElement p : priceElements) {

                                String text = p.getText();

                                if (text.matches(".*\\d+.*")) {
                                    price = text.replaceAll("[^0-9]", "") + " МКД";
                                    break;
                                }
                            }

                        } catch (Exception ignored) {}

                        driver.close();
                        driver.switchTo().window(tabs.get(0));

                    } catch (Exception ignored) {}
                }

                events.add(new Event(
                        title,
                        date,
                        location,
                        imageUrl,
                        price,
                        buyUrl,
                        "MKTickets",
                        genre,
                        description
                ));
            }

        } finally {
            driver.quit();
        }

        return events;
    }


    /* ========================================================= */
    /* ======================= SCHEDULER ======================= */
    /* ========================================================= */

    @Scheduled(fixedRate = 600000) 
    public void updateEvents() {

        System.out.println("Updating events...");

        List<Event> fresh = new ArrayList<>();

        fresh.addAll(fetchKupikartaEvents());
        fresh.addAll(scrapeTicketX());
        fresh.addAll(scrapeMktickets());

        cachedEvents = fresh;

        System.out.println("Events updated: " + cachedEvents.size());
    }

    public List<Event> getAllEvents() {
        return cachedEvents;
    }
}