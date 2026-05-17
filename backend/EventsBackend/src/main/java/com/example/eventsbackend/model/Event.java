package com.example.eventsbackend.model;

public class Event {
    private String title;
    private String date;
    private String location;
    private String imageUrl;
    private String price;
    private String buyUrl;
    private String source;
    private String genre;

    private String description;

    public Event(){}

    public Event (String title, String date, String location, String imageUrl, String price, String buyUrl, String source, String genre, String description){
        this. title = title;
        this.date = date;
        this.location = location;
        this. imageUrl = imageUrl;
        this.price = price;
        this.buyUrl = buyUrl;
        this.source = source;
        this.genre = genre;
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getBuyUrl() {
        return buyUrl;
    }

    public void setBuyUrl(String buyUrl) {
        this.buyUrl = buyUrl;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getGenre() {
        return genre;
    }
    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
