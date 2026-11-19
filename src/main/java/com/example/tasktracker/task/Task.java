package com.example.tasktracker.task;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import java.time.Instant;

/**
 * A single to-do item. JPA maps this class to a "task" table in the database.
 */
@Entity
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // the database assigns the id
    private Long id;

    @Column(nullable = false)
    private String title;

    private boolean done;

    private Instant createdAt;

    /** JPA needs a no-argument constructor to create objects from database rows. */
    protected Task() {
    }

    public Task(String title, boolean done) {
        this.title = title;
        this.done = done;
    }

    /** Runs automatically right before the first INSERT. */
    @PrePersist
    void onCreate() {
        this.createdAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isDone() {
        return done;
    }

    public void setDone(boolean done) {
        this.done = done;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
