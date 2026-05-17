package com.example.eventsbackend.controller;

import com.example.eventsbackend.model.Event;
import com.example.eventsbackend.service.EventsScraperService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class EventsController {

    private final EventsScraperService eventsScraperService;

    public EventsController(EventsScraperService eventsScraperService) {
        this.eventsScraperService = eventsScraperService;
    }

    @GetMapping("/events")
    public List<Event> getEvents() {
        return eventsScraperService.getAllEvents();
    }

}

