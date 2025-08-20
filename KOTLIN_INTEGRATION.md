# Kotlin Integration with Method Channels

This document explains how to integrate Kotlin code with your Flutter project using Method Channels. This is useful for accessing platform-specific APIs that are not available in Dart.

## 1. MethodChannel in Dart

First, you need to create a `MethodChannel` in your Dart code. It's a good practice to wrap this in a dedicated class.

```dart
// lib/services/platform_channel.dart

import 'package:flutter/services.dart';

class PlatformChannel {
  static const MethodChannel _channel = MethodChannel('com.example.amar_hisab/channel');

  static Future<String?> getPlatformVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      print("Failed to get platform version: '${e.message}'.");
      return null;
    }
  }
}
```

## 2. MethodCallHandler in Kotlin

Next, you need to implement the `MethodCallHandler` in your `MainActivity.kt` file. This is where you will handle the method calls from your Dart code.

```kotlin
// android/app/src/main/kotlin/com/example/amar_hisab/MainActivity.kt

package com.example.amar_hisab

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.amar_hisab/channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getPlatformVersion") {
                result.success("Android ${Build.VERSION.RELEASE}")
            } else {
                result.notImplemented()
            }
        }
    }
}
```

## 3. Usage in Flutter

Now you can call the native method from your Dart code like this:

```dart
// Example usage in a widget
import 'package:amar_hisab/services/platform_channel.dart';

// ...

String? _platformVersion;

@override
void initState() {
  super.initState();
  _getPlatformVersion();
}

Future<void> _getPlatformVersion() async {
  String? platformVersion;
  try {
    platformVersion = await PlatformChannel.getPlatformVersion();
  } catch (e) {
    platformVersion = 'Failed to get platform version.';
  }

  if (!mounted) return;

  setState(() {
    _platformVersion = platformVersion;
  });
}

// ...

// Display the platform version in your widget
Text(_platformVersion ?? 'Unknown');
```