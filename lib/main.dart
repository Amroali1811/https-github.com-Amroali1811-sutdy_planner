import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: app bar with the app title
      appBar: AppBar(title: const Text('My Study Planner')),

      body: Column(
        children: [
          // STATIC: heading above the list
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('My Goals', style: TextStyle(fontSize: 22)),
          ),

          // STATIC: hard-coded goal cards
          Card(
            child: ListTile(
              title: const Text('Math'),
              subtitle: const Text('4 hours'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Physics'),
              subtitle: const Text('3 hours'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Programming'),
              subtitle: const Text('5 hours'),
            ),
          ),
        ],
      ),

      // STATIC: add button (does nothing yet)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}