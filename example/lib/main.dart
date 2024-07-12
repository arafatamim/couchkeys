// Builds a custom Couchkeys number pad

import 'package:couchkeys/couchkeys.dart';
import 'package:couchkeys/keyboard_action.dart';
import 'package:couchkeys/text_key.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'couchkeys',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'couchkeys'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 512,
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Couchkeys(
              keyboardHeight: 200,
              controller: controller,
              customLayout: [
                ["1", "2", "3", "-"]
                    .map(
                      (v) => TextKey(
                        label: v,
                        action: InsertAction(v),
                      ),
                    )
                    .toList(),
                ["4", "5", "6"]
                    .map((v) => TextKey(
                          label: v,
                          action: InsertAction(v),
                        ))
                    .followedBy(
                  [
                    TextKey(
                      label: "␣",
                      action: SpaceAction(),
                    )
                  ],
                ).toList(),
                ["7", "8", "9"]
                    .map((v) => TextKey(
                          label: v,
                          action: InsertAction(v),
                        ))
                    .followedBy(
                  [
                    TextKey(
                      label: "⌫",
                      action: BackspaceAction(),
                    )
                  ],
                ).toList(),
                [".", "0", ","]
                    .map((v) => TextKey(
                          label: v,
                          action: InsertAction(v),
                        ))
                    .followedBy(
                  [
                    TextKey(
                      label: "↵",
                      onTap: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Submitted: ${controller.text}"),
                          ),
                        );

                      },
                    )
                  ],
                ).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
