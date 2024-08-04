library couchkeys;

import 'package:couchkeys/couchkeys.dart';
import 'package:flutter/material.dart';

/// A customizable virtual keyboard.
/// It provides a simple interface for creating a custom keyboard layout. The keyboard can be customized with a custom layout, button style, and height.
///
/// The keyboard is built around [KeyboardKey] widgets, which are used to define the layout of the keyboard. It is designed to be used in conjunction with a [TextEditingController].
class Couchkeys extends StatefulWidget {
  /// Callback triggered when the text changes.
  final ValueChanged<String>? onChanged;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines a custom layout for the keyboard.
  ///
  /// If null, a default layout will be used.
  final List<List<KeyboardKey>>? customLayout;

  /// Customizes the appearance of the keys.
  /// If a key has its own style, it will merge with this style, overriding any duplicate properties.
  final ButtonStyle? buttonStyle;

  /// The height of the keyboard.
  /// Defaults to 200.
  final double? keyboardHeight;

  /// Transforms the text before it is inserted into the controller for advanced functionality.
  final String? Function(String? incomingValue)? textTransformer;

  /// Creates a new instance of [Couchkeys].
  /// Example:
  /// ```dart
  /// Couchkeys(
  ///   controller: controller,
  ///   keyboardHeight: 200,
  /// )
  /// ```
  const Couchkeys({
    super.key,
    this.onChanged,
    this.controller,
    this.customLayout,
    this.keyboardHeight,
    this.textTransformer,
    this.buttonStyle,
  });

  @override
  State<Couchkeys> createState() => _CouchkeysState();
}

class _CouchkeysState extends State<Couchkeys> {
  TextEditingController? _controller;
  late final List<List<KeyboardKey>> _keyLayout;

  TextEditingController get effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _createLocalController();

    _keyLayout = widget.customLayout ?? _defaultLayout;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.keyboardHeight ?? 200,
      child: Column(
        children: [
          for (final row in _keyLayout)
            _buildRowOfWidgets(
              row.map((keyWidget) {
                final style =
                    keyWidget.style != null && widget.buttonStyle != null
                        ? keyWidget.style!.merge(widget.buttonStyle!)
                        : keyWidget.style ?? widget.buttonStyle;
                final onTap = keyWidget.onTap ?? _handleAction;
                return KeyboardKey(
                  action: keyWidget.action,
                  style: style,
                  onTap: onTap,
                  flex: keyWidget.flex,
                  key: keyWidget.key,
                  child: keyWidget.child,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleAction(action) {
    switch (action) {
      case InsertAction(value: final value):
        _insertHandler(value);
        break;
      case ClearAction():
        _clearHandler();
        break;
      case BackspaceAction():
        _backspaceHandler();
        break;
      case SpaceAction():
        _spaceHandler();
        break;
      default:
    }
  }

  void onChangedCallback() => widget.onChanged?.call(effectiveController.text);

  Widget _buildRowOfWidgets(List<KeyboardKey> keys) {
    return Expanded(
      child: Row(
        children: [for (final key in keys) key],
      ),
    );
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? TextEditingController()
        : TextEditingController.fromValue(value);
  }

  void _clearHandler() {
    effectiveController.text = "";
    onChangedCallback();
  }

  void _spaceHandler() {
    if (effectiveController.text != "") {
      effectiveController.text = "${effectiveController.text.trim()} ";
    }
    onChangedCallback();
  }

  void _backspaceHandler() {
    if (effectiveController.text.isNotEmpty) {
      effectiveController.text = effectiveController.text
          .substring(0, effectiveController.text.length - 1);
    }
    onChangedCallback();
  }

  void _insertHandler(String? text) {
    if (text != null) {
      if (widget.textTransformer != null) {
        effectiveController.text =
            effectiveController.text + widget.textTransformer!(text)!;
      } else {
        effectiveController.text = effectiveController.text + text;
      }
    }
    onChangedCallback();
  }

  final List<List<KeyboardKey>> _defaultLayout = [
    ["A", "B", "C", "D", "E", "F", "G", "1", "2", "3"]
        .map(
          (v) => KeyboardKey(
            action: InsertAction(v),
            child: Text(v),
          ),
        )
        .toList(),
    ["H", "I", "J", "K", "L", "M", "N", "4", "5", "6"]
        .map(
          (v) => KeyboardKey(
            action: InsertAction(v),
            child: Text(v),
          ),
        )
        .toList(),
    ["O", "P", "Q", "R", "S", "T", "U", "7", "8", "9"]
        .map(
          (v) => KeyboardKey(
            action: InsertAction(v),
            child: Text(v),
          ),
        )
        .toList(),
    ["V", "W", "X", "Y", "Z", "-", "'", "&", "0", "@"]
        .map(
          (v) => KeyboardKey(
            action: InsertAction(v),
            child: Text(v),
          ),
        )
        .toList(),
    [
      KeyboardKey(
        action: ClearAction(),
        child: const Text("Clear"),
      ),
      KeyboardKey(
        action: SpaceAction(),
        flex: 2,
        child: const Text("Space"),
      ),
      KeyboardKey(
        action: BackspaceAction(),
        child: const Icon(Icons.backspace),
      ),
    ],
  ];
}
