import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(ChangeNotifierProvider(
    create: (context) => Counter(),
    child: const MyApp(),
  ));
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
  }
}

class Counter with ChangeNotifier {
  int age = 0;

  void setAge(double newAge) {
    age = newAge.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color getBackgroundColor(int age) {
    if (age <= 12) return Colors.lightBlueAccent;
    if (age <= 19) return Colors.purpleAccent;
    if (age <= 30) return Colors.greenAccent;
    if (age <= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String getMilestoneMessage(int age) {
    if (age <= 12) return "You're a child!";
    if (age <= 19) return "Teenage years!";
    if (age <= 30) return "Young adult!";
    if (age <= 50) return "Mature and thriving!";
    return "Golden years!";
  }

  Color getProgressBarColor(int age) {
    if (age <= 33) return Colors.green;
    if (age <= 67) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          backgroundColor: getBackgroundColor(counter.age),
          appBar: AppBar(
            title: const Text('Age Counter'),
            backgroundColor: Colors.blueGrey,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your current age:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${counter.age}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                getMilestoneMessage(counter.age),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Slider(
                  value: counter.age.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: '${counter.age}',
                  onChanged: (value) {
                    counter.setAge(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: counter.age / 99,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    getProgressBarColor(counter.age),
                  ),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
