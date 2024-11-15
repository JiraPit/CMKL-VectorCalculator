import 'package:flutter/material.dart';
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/input_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int vectorCount = 2;
  int operationsCount = 1;
  List<bool> operationSelections = [];

  @override
  void initState() {
    super.initState();
    operationSelections = List.generate(operationsCount, (_) => false);
  }

  void addVector() {
    setState(() {
      vectorCount++;
    });
  }

  void addOperation() {
    setState(() {
      operationsCount++;
      operationSelections.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Vector Operations Visualizer',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width:
              800, // Set a fixed width for the entire content to keep it centered
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left side - Vectors Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 52,
                          childAspectRatio: 4,
                        ),
                        itemCount: vectorCount,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vector V${index + 1}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const InputBox(
                                hintText: '(x, y, z)',
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: addVector,
                      child: Container(
                        height: 66,
                        width: 263,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC289),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 19.0),
                          child: Text(
                            'ADD VECTOR',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right side - Operations Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 16,
                          childAspectRatio: 4,
                        ),
                        itemCount: operationsCount,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Resultant ${index + 1}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        const InputBox(
                                          hintText: 'v1 + v2',
                                        ),
                                        Checkbox(
                                          value: operationSelections[index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              operationSelections[index] =
                                                  value ?? false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: addOperation,
                      child: Container(
                        height: 66,
                        width: 263,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC289),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 19.0),
                          child: Text(
                            'ADD OPERATION',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
