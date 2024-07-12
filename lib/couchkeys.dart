library couchkeys;

import 'package:couchkeys/keyboard_action.dart';
import 'package:couchkeys/text_key.dart';
import 'package:flutter/material.dart';

class Couchkeys extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final List<List<TextKey>>? customLayout;
  final double? keyboardHeight;
  final String? Function(String? incomingValue)? textTransformer;

  const Couchkeys({
    super.key,
    this.onChanged,
    this.controller,
    this.customLayout,
    this.keyboardHeight,
    this.textTransformer,
  });

  @override
  CouchkeysState createState() => CouchkeysState();
}

class CouchkeysState extends State<Couchkeys> {
  TextEditingController? _controller;
  late final List<List<TextKey>> _keyLayout;

  TextEditingController get effectiveController =>
      widget.controller ?? _controller!;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.keyboardHeight ?? 170,
      // color: Colors.transparent,
      child: Column(
        children: [
          for (final row in _keyLayout)
            _buildRowOfWidgets(
              row.map((widget) {
                return TextKey(
                  label: widget.label,
                  icon: widget.icon,
                  action: widget.action,
                  onTap: widget.onTap ??
                      (action) {
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
                      },
                  flex: widget.flex,
                  color: widget.color,
                  foregroundColor: widget.foregroundColor,
                  key: widget.key,
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

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _createLocalController();

    _keyLayout = widget.customLayout ??
        [
          ["A", "B", "C", "D", "E", "F", "G", "1", "2", "3"]
              .map(
                (v) => TextKey(
                  label: v,
                  action: InsertAction(v),
                ),
              )
              .toList(),
          ["H", "I", "J", "K", "L", "M", "N", "4", "5", "6"]
              .map(
                (v) => TextKey(
                  label: v,
                  action: InsertAction(v),
                ),
              )
              .toList(),
          ["O", "P", "Q", "R", "S", "T", "U", "7", "8", "9"]
              .map(
                (v) => TextKey(
                  label: v,
                  action: InsertAction(v),
                ),
              )
              .toList(),
          ["V", "W", "X", "Y", "Z", "-", "'", "&", "0", "@"]
              .map(
                (v) => TextKey(
                  label: v,
                  action: InsertAction(v),
                ),
              )
              .toList(),
          [
            TextKey(
              label: "Clear",
              action: ClearAction(),
            ),
            TextKey(
              label: "Space",
              action: SpaceAction(),
              flex: 2,
            ),
            TextKey(
              icon: Icons.backspace,
              action: BackspaceAction(),
            ),
          ],
        ];
  }

  void onChangedCallback() => widget.onChanged?.call(effectiveController.text);

  // Widget _buildRowOfStrings(List<String> keys) {
  //   return _buildRowOfWidgets(keys
  //       .map((key) => TextKey(
  //             text: key,
  //             onTap: _textInputHandler,
  //           ))
  //       .toList());
  // }

  Widget _buildRowOfWidgets(List<TextKey> keys) {
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

  void _clearHandler([String? _]) {
    effectiveController.text = "";
    onChangedCallback();
  }

  void _spaceHandler([String? _]) {
    if (effectiveController.text != "") {
      effectiveController.text = "${effectiveController.text.trim()} ";
    }
    onChangedCallback();
  }

  void _backspaceHandler([String? _]) {
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
}
