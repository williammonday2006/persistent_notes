Phase 1
The ?? operator provides a default value of false if no preference is saved. Without it, the value could be null and cannot be assigned to a non-nullable bool.

Phase 2
Testing file writes with the console helps make sure data saves correctly before displaying it in the UI. The NoteStorage class keeps file operations separate, making the code easier to organize and maintain.