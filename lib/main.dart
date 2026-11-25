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

  // LOGIC: statistics (getters), recalculated every time the screen rebuilds
  int get totalHours =>
      goals.fold(0, (sum, goal) => sum + (goal['hours'] as int));

  int get completedCount =>
      goals.where((goal) => goal['done'] == true).length;

  int get remainingCount => goals.length - completedCount;

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

  // LOGIC: add a goal to the list
  void addGoal(Map<String, dynamic> goal) {
    setState(() {
      goals.add(goal);
    });
  }

  // LOGIC: open the add screen, wait for the result, ignore it if user pressed back
  Future<void> openAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGoalScreen()),
    );
    if (result != null) {
      addGoal(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: app bar with the app title
      appBar: AppBar(title: const Text('My Study Planner')),

      body: Column(
        children: [
          // STATIC: summary row with three equal cards
          // CONNECTION 3: the cards read values from the LOGIC getters
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total hours',
                    value: totalHours,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: 'Completed',
                    value: completedCount,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: 'Remaining',
                    value: remainingCount,
                  ),
                ),
              ],
            ),
          ),

          // STATIC: heading above the list
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('My Goals', style: TextStyle(fontSize: 22)),
          ),

          // STATIC: empty message OR the list built from the goals data
          Expanded(
            child: goals.isEmpty
                ? const Center(
                    child: Text(
                      'No goals yet. Tap + to add one!',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Card(
                        child: ListTile(
                          // CONNECTION 1: tap or checkbox calls toggleGoal
                          onTap: () => toggleGoal(index),
                          leading: Checkbox(
                            value: goal['done'],
                            onChanged: (value) => toggleGoal(index),
                          ),
                          title: Text(
                            goal['subject'],
                            style: TextStyle(
                              decoration: goal['done']
                                  ? TextDecoration.lineThrough
                                  : null,
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

      // STATIC: add button, opens the second screen
      // CONNECTION 4: the button calls openAddScreen
      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// STATIC: ONE reusable card widget, used three times in the summary row
class SummaryCard extends StatelessWidget {
  final String title;
  final int value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ===================== SECOND SCREEN =====================

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // LOGIC: controllers read what the user typed
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  // LOGIC: error messages (null means no error)
  String? subjectError;
  String? hoursError;

  // LOGIC: validate the input, then send the new goal back with Navigator.pop
  void saveGoal() {
    final subject = subjectController.text.trim();
    final hours = int.tryParse(hoursController.text.trim());

    setState(() {
      subjectError = subject.isEmpty ? 'Subject cannot be empty' : null;
      hoursError = (hours == null || hours <= 0)
          ? 'Hours must be a number greater than 0'
          : null;
    });

    // stop here if anything is invalid
    if (subjectError != null || hoursError != null) {
      return;
    }

    Navigator.pop(context, {
      'subject': subject,
      'hours': hours,
      'done': false,
    });
  }

  // LOGIC: free the controllers when the screen closes
  @override
  void dispose() {
    subjectController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: app bar of the second screen
      appBar: AppBar(title: const Text('Add Goal')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // STATIC: subject field
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                errorText: subjectError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // STATIC: hours field (numbers only keyboard)
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hours',
                errorText: hoursError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // STATIC: save button
            // CONNECTION 5: the button calls saveGoal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveGoal,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}