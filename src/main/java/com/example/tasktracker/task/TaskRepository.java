package com.example.tasktracker.task;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Spring Data generates the implementation at startup:
 * findAll(), findById(), save(), delete() and more, with no SQL written by hand.
 */
public interface TaskRepository extends JpaRepository<Task, Long> {
}
