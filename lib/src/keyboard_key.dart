import 'package:couchkeys/couchkeys.dart';
import 'package:flutter/material.dart';

/// This widget is used to define the layout of the [Couchkeys] keyboard.
/// The layout is defined as a list of rows on [Couchkeys.customLayout] property, where each row is a list of [KeyboardKey] widgets.
///
/// The widget expects a [child] to display on the key, and an [action] to perform when the key is pressed. The [action] can be one of the following:
/// - [InsertAction(String)]
/// - [BackspaceAction]
/// - [SpaceAction]
/// - [ClearAction]
class KeyboardKey extends StatefulWidget {
  /// The label to display on the key.
  final Widget? child;

  /// The action to perform when the key is pressed.
  /// Takes a [KeyboardAction] as an argument, which is one of the following:
  /// - [InsertAction(String)]
  /// - [BackspaceAction]
  /// - [SpaceAction]
  /// - [ClearAction]
  final KeyboardAction? action;

  /// Callback triggered on key press to set custom behavior. Not required if [action] is set.
  final ValueSetter<KeyboardAction?>? onTap;

  /// Callback triggered on long key press.
  final ValueSetter<KeyboardAction?>? onLongPress;

  /// Controls how the space in a row is distributed among the keys.
  /// A value of 2 will make the key occupy twice the width of a key with a value of 1.
  ///
  /// Default value is 1.
  final int flex;

  /// Customizes the appearance of the key.
  /// If parent [Couchkeys] has a [buttonStyle], it will merge with this style, overriding any duplicate properties.
  final ButtonStyle? style;

  /// The space around the key.
  ///
  /// Default value is 2.
  final double gap;

  /// Creates a new instance of [KeyboardKey]. [child] must be specified.
  /// Example:
  /// ```dart
  /// KeyboardKey(
  ///   action: InsertAction('a'),
  ///   child: const Text('A'),
  /// )
  /// ```
  const KeyboardKey({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.action,
    this.flex = 1,
    this.style,
    this.gap = 2,
  });

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.all(widget.gap),
          child: TextButton(
            style: widget.style,
            onPressed: _onTap,
            onLongPress: _onLongPress,
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    widget.onTap?.call(widget.action);
  }

  void _onLongPress() {
    widget.onLongPress?.call(widget.action);
  }
}
