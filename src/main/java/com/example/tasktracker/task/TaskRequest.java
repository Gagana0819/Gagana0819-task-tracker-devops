package com.example.tasktracker.task;

import jakarta.validation.constraints.NotBlank;

/**
 * The JSON body clients send to create or update a task, e.g. {"title":"Learn Docker","done":false}.
 * "done" is a Boolean (not boolean) so it may be left out of the JSON; null is treated as false.
 */
public record TaskRequest(@NotBlank String title, Boolean done) {
}
