package com.example.eventsbackend.model;

public class TicketX {
    public String title;
    public String date;
    public String location;
    public String imageUrl;
    public String buyUrl;
    public String genre;

    public TicketX(String title, String date, String location,
                       String imageUrl, String buyUrl, String genre) {

        this.title = title;
        this.date = date;
        this.location = location;
        this.imageUrl = imageUrl;
        this.buyUrl = buyUrl;
        this.genre = genre;
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

    public String getBuyUrl() {
        return buyUrl;
    }

    public void setBuyUrl(String buyUrl) {
        this.buyUrl = buyUrl;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }
}
