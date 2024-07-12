# couchkeys

[![Pub Package](https://img.shields.io/pub/v/couchkeys.svg)](https://pub.dartlang.org/packages/couchkeys)
[![Pub Points](https://img.shields.io/pub/points/couchkeys?color=2E8B57&label=pub%20points)](https://pub.dev/packages/couchkeys/score)

A customizable virtual keyboard package for Flutter applications, specifically designed for
use with D-pad navigation on devices like smart TVs and set-top boxes.

Inspired by the YouTube app for Android TV.

![image](https://github.com/user-attachments/assets/70ccf2c0-2dbc-4677-aad1-3aac8a4d0ad2)

> [!WARNING]
> This package is currently in an early development stage and is not considered stable. It may contain bugs, incomplete features, or undergo significant changes in future releases. Use it at your own risk in production environments.

## Features

- Fully customizable keyboard layout
- Customizable key appearance and behavior
- Easy integration with Flutter `TextFields`

## Getting started

Add this to your `pubspec.yaml` file:
```yaml
dependencies:
  couchkeys: ^0.0.1
```
Then run:
```sh
flutter pub get
```

## Usage

```dart
...
// Import the package
import 'package:couchkeys/couchkeys.dart';

...
class _MyHomePageState extends State<MyHomePage> {
    // Create a controller to use with both Couchkeys and TextField
    final controller = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            ...
            body: Column(
                children: [
                    SizedBox(
                        width: 500,
                        // Create the Couchkeys widget
                        child: Couchkeys(
                            keyboardHeight: 200,
                            controller: controller,
                        )
                    ),
                    // Create TextField widget with a controller to display the value
                    TextField(controller: controller),
                ]
            )
        )
    }
}
```

## Documentation

Detailed API documentation can be found on [pub.dev](https://pub.dev/documentation/couchkeys).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or file an Issue on [GitHub](https://github.com/arafatamim/couchkeys).

## License

This project is MIT Licensed. See [LICENSE](https://github.com/arafatamim/couchkeys/blob/main/LICENSE) file for details.
