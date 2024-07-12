sealed class KeyboardAction {}

class InsertAction extends KeyboardAction {
  final String value;

  InsertAction(this.value);
}

class ClearAction extends KeyboardAction {}

class BackspaceAction extends KeyboardAction {}

class SpaceAction extends KeyboardAction {}
