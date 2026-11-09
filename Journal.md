Phase 1
The ?? operator provides a default value of false if no preference is saved. Without it, the value could be null and cannot be assigned to a non-nullable bool.

Phase 2
Testing file writes with the console helps make sure data saves correctly before displaying it in the UI. The NoteStorage class keeps file operations separate, making the code easier to organize and maintain.

Phase 3
If a file does not exist, readAsString() throws an exception. The try/catch block catches the error and returns a default message instead of crashing the app.

Phase 4
I tested saving and loading notes, restarting the app, and switching between light and dark mode. Everything worked as expected, and I learned how to use SharedPreferences and file storage to keep data between app launches.