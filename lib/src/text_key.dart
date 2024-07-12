import 'package:couchkeys/couchkeys.dart';
import 'package:flutter/material.dart';

class TextKey extends StatefulWidget {
  /// The text to display on the key.
  final String? label;

  /// The icon to display on the key.
  final IconData? icon;

  /// The action to perform when the key is pressed.
  /// Takes a [KeyboardAction] as an argument, which is one of the following:
  /// - [InsertAction(String)]
  /// - [BackspaceAction]
  /// - [SpaceAction]
  /// - [ClearAction]
  final KeyboardAction? action;

  /// Callback triggered on key press to set custom behavior. Not required if [action] is set.
  final ValueSetter<KeyboardAction?>? onTap;

  /// Expands the key to fill the available space.
  /// Default is 1.
  final int flex;

  /// The background color of the key.
  /// Takes a [WidgetStateColor] as an argument, which is a function that takes a set of [WidgetState]s and returns a [Color].
  /// Default is white when focused, black with 100 alpha otherwise.
  final WidgetStateColor? color;

  /// The text color of the key.
  /// Takes a [WidgetStateColor] as an argument, which is a function that takes a set of [WidgetState]s and returns a [Color].
  /// Default is black when focused, white otherwise.
  final WidgetStateColor? foregroundColor;

  /// Creates a new instance of [TextKey].
  /// Either [label] or [icon] must be specified.
  /// Example:
  /// ```dart
  /// TextKey(
  ///   label: 'A',
  ///   action: InsertAction('A'),
  /// )
  /// ```
  const TextKey({
    super.key,
    this.label,
    this.icon,
    this.onTap,
    this.action,
    this.flex = 1,
    this.color,
    this.foregroundColor,
  })  : assert(
          icon != null || label != null,
          "Either icon or label must be specified",
        ),
        super();

  @override
  State<TextKey> createState() => _TextKeyState();
}

class _TextKeyState extends State<TextKey> {
  late FocusNode _node;
  late Color _primaryColor;
  late Color _textColor;

  WidgetStateColor get color =>
      widget.color ??
      WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? Colors.white
            : Colors.black.withAlpha(100),
      );
  WidgetStateColor get foregroundColor =>
      widget.foregroundColor ??
      WidgetStateColor.resolveWith(
        (states) =>
            states.contains(WidgetState.focused) ? Colors.black : Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RawMaterialButton(
          focusNode: _node,
          onPressed: _onTap,
          focusColor: Colors.transparent,
          focusElevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: widget.label != null
                  ? Text(
                      widget.label!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _textColor,
                            fontSize: 20.0,
                          ),
                    )
                  : Icon(
                      widget.icon,
                      color: _textColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _primaryColor = color.resolve({});
    _textColor = foregroundColor.resolve({});

    _node = FocusNode();
    _node.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _primaryColor = color.resolve({WidgetState.focused});
        _textColor = foregroundColor.resolve({WidgetState.focused});
      });
    } else {
      setState(() {
        _primaryColor = color.resolve({});
        _textColor = foregroundColor.resolve({});
      });
    }
  }

  void _onTap() {
    _node.requestFocus();
    widget.onTap?.call(widget.action);
  }
}
