import 'package:flutter/material.dart';
import 'package:couchkeys/keyboard_action.dart';

class TextKey extends StatefulWidget {
  const TextKey({
    super.key,
    this.label,
    this.icon,
    this.onTap,
    required this.action,
    this.flex = 1,
    this.color,
    this.foregroundColor,
  })  : assert(
          icon != null || label != null,
          "Either icon or text must be specified",
        ),
        super();

  final String? label;
  final IconData? icon;
  final KeyboardAction action;
  final ValueSetter<KeyboardAction>? onTap;
  final int flex;
  final WidgetStateColor? color;
  final WidgetStateColor? foregroundColor;

  @override
  TextKeyState createState() => TextKeyState();
}

class TextKeyState extends State<TextKey> with TickerProviderStateMixin {
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

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

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
}
