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
  // LOGIC: goals data
  List<Map<String, dynamic>> goals = [
    {'subject': 'Math', 'hours': 4, 'done': false},
    {'subject': 'Physics', 'hours': 3, 'done': false},
    {'subject': 'Programming', 'hours': 5, 'done': false},
  ];

  // LOGIC: toggle done / not done
  void toggleGoal(int index) {
    setState(() {
      goals[index]['done'] = !goals[index]['done'];
    });
  }

  // LOGIC: delete a goal
  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  // LOGIC: add a sample goal
  void addSampleGoal() {
    setState(() {
      goals.add({'subject': 'New Goal', 'hours': 2, 'done': false});
    });
  }

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

          // STATIC: list layout, items are built from the goals data
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Card(
                  child: ListTile(
                    // CONNECTION 1: tapping the tile or checkbox calls toggleGoal
                    onTap: () => toggleGoal(index),
                    leading: Checkbox(
                      value: goal['done'],
                      onChanged: (value) => toggleGoal(index),
                    ),
                    title: Text(
                      goal['subject'],
                      style: TextStyle(
                        decoration:
                            goal['done'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('${goal['hours']} hours'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      // CONNECTION 2: delete button calls deleteGoal
                      onPressed: () => deleteGoal(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // STATIC: add button, adds a sample goal for now
      floatingActionButton: FloatingActionButton(
        onPressed: addSampleGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}