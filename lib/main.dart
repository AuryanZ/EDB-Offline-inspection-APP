import 'dart:io';
import 'package:app/src/screens/home.screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if use chrome os, set window size
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('TLC Offline Inspection App');
    setWindowMaxSize(const Size(3840, 2160));
    setWindowMinSize(const Size(1200, 1000));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Inspection App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Offline Inspection App'),
        // '/inspection': (context) =>
        //     const InspectionFormScreen(title: 'Inspection Form'),
        // '/camera': (context) => const CameraScreen(title: 'cam',),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      // home: const HomePage(title: 'Offline Inspection App'),
    );
  }
}
