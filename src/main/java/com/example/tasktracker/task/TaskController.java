package com.example.tasktracker.task;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * REST API for tasks. Every method returns JSON.
 */
@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskRepository repository;

    // Constructor injection: Spring passes in the TaskRepository it created.
    public TaskController(TaskRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Task> list() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public Task get(@PathVariable Long id) {
        return findOr404(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED) // 201
    public Task create(@Valid @RequestBody TaskRequest request) {
        return repository.save(new Task(request.title(), Boolean.TRUE.equals(request.done())));
    }

    @PutMapping("/{id}")
    public Task update(@PathVariable Long id, @Valid @RequestBody TaskRequest request) {
        Task task = findOr404(id);
        task.setTitle(request.title());
        task.setDone(Boolean.TRUE.equals(request.done()));
        return repository.save(task);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT) // 204
    public void delete(@PathVariable Long id) {
        repository.delete(findOr404(id));
    }

    private Task findOr404(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Task " + id + " not found"));
    }
}
