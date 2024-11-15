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
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Vectors Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(vectorCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vector V${index + 1}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          const InputBox(
                            hintText: '(x, y, z)',
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: addVector,
                  child: Container(
                    height: 66,
                    width: 263,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC289),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'ADD VECTOR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

            const SizedBox(width: 200),

            // Right side - Operations Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(operationsCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resultant ${index + 1}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const InputBox(
                                hintText: 'v1 + v2',
                              ),
                              Checkbox(
                                value: operationSelections[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    operationSelections[index] = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: addOperation,
                  child: Container(
                    height: 66,
                    width: 263,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC289),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'ADD OPERATION',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
