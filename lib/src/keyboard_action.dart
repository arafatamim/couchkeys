sealed class KeyboardAction {}

class InsertAction extends KeyboardAction {
  final String value;

  /// Represents a key press that inserts a character into the text field.
  /// Takes a [value] parameter that represents the character to insert.
  InsertAction(this.value);
}

/// Represents a key press that clears the text field.
class ClearAction extends KeyboardAction {}

/// Represents a key press that deletes the last character in the text field.
class BackspaceAction extends KeyboardAction {}

/// Represents a key press that inserts a space character into the text field.
class SpaceAction extends KeyboardAction {}
