import 'package:flutter/material.dart';
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/row_builder.dart';

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

  void draw() {
    debugPrint('Draw button pressed');
    setState(() {});
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Vectors Section
                RowBuilder(
                  itemCount: vectorCount,
                  labelPrefix: 'Vector V',
                  inputHint: '(x, y, z)',
                  buttonText: 'ADD VECTOR',
                  onAddItem: addVector,
                ),

                const SizedBox(width: 200),

                // Right side - Operations Section
                RowBuilder(
                  itemCount: operationsCount,
                  labelPrefix: 'Resultant',
                  inputHint: 'v1 + v2',
                  buttonText: 'ADD EXPRESSION',
                  onAddItem: addOperation,
                  hasCheckbox: true,
                  operationSelections: operationSelections,
                  onCheckboxChanged: (index, value) {
                    setState(() {
                      operationSelections[index] = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 70),
            Container(
              height: 1,
              width: 1263,
              color: Colors.black,
            ),
            const SizedBox(height: 61),
            Center(
              child: Container(
                width: 263,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color(0xFF66E16C),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "DRAW!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
