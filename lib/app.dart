import 'package:flutter/material.dart';

class PropertyHubApp extends StatelessWidget {
  const PropertyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PropertyHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('PropertyHub connected to Firebase!'),
        ),
      ),
    );
  }
}
