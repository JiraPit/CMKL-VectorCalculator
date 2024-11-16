import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // New import
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/row_builder.dart'; // New import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int vectorCount = 2;
  int operationsCount = 1;

  List<bool> operationSelections = [];
  List<String> vectors = [];
  List<String> operations = [];
  List<String> results = []; // Holds the results to display
  String? graphHtmlContent; // Variable to hold the HTML content for the graph

  @override
  void initState() {
    super.initState();
    // Initialize operation selections and lists
    operationSelections = List.generate(operationsCount, (_) => false);
    vectors = List.generate(vectorCount, (_) => '');
    operations = List.generate(operationsCount, (_) => '');
  }

  void updateVector(int index, String value) {
    setState(() {
      if (index < vectors.length) {
        vectors[index] = value;
      }
    });
  }

  void updateOperation(int index, String value) {
    setState(() {
      if (index < operations.length) {
        operations[index] = value;
      }
    });
  }

  void addVector() {
    setState(() {
      vectorCount++;
      vectors.add('');
    });
  }

  void addOperation() {
    setState(() {
      operationsCount++;
      operations.add('');
      operationSelections.add(false);
    });
  }

  // Function to get the evaluation results from the server
  Future<void> getEvaluation() async {
    // Construct the request body
    final body = {
      "vectors": {
        for (int i = 0; i < vectorCount; i++)
          'v${i + 1}': _parseVector(vectors[i]),
      },
      "expressions": [
        for (int i = 0; i < operationsCount; i++)
          if (operationSelections[i]) operations[i],
      ],
    };

    // Print the body
    debugPrint('Request: $body');

    try {
      // Make an HTTP POST request
      final response = await http.post(
        Uri.parse(
            'https://vector-calculator-server-968431016.asia-southeast1.run.app/evaluate'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        // Decode the JSON string into a dynamic structure
        final jsonResponse = jsonDecode(response.body);

        debugPrint('Response: $jsonResponse');

        // Check if the response contains results and update the results list
        if (jsonResponse != null) {
          setState(() {
            // Clear any previous results
            results.clear();

            // Loop through the response and format it for display
            jsonResponse.forEach((operation, result) {
              // Check if the result is "ERROR"
              if (result == "ERROR") {
                results.add('$operation: INVALID');
              } else {
                String resultStr = result.map((e) => e.toString()).join(', ');
                results.add('$operation: [$resultStr]');
              }
            });
          });
        } else {
          setState(() {
            results = ['Error: No results found in the response'];
          });
        }
      } else {
        debugPrint('Error: HTTP ${response.statusCode}, ${response.body}');
        setState(() {
          results = ['Error: HTTP ${response.statusCode}'];
        });
      }
    } catch (e) {
      debugPrint('Exception during HTTP POST: $e');
      setState(() {
        results = ['Exception: $e'];
      });
    }
  }

  Future<void> getGraph() async {
    debugPrint('Getting graph');

    // Construct the request body by extracting only the numbers after the colon
    final body = {
      "vectors": {
        for (int i = 0; i < results.length; i++)
          if (!results[i].contains('INVALID'))
            // Set the key to the first part of results before the colon
            '${results[i].split(':')[0].trim()}': _parseVector(
              // Set the value to the numbers after the colon
              results[i]
                  .split(':')[1]
                  .trim()
                  .substring(1, results[i].length - 1),
            ),
      }
    };

    // Print the body for debugging
    debugPrint('Request Body: $body');

    try {
      // Make an HTTP POST request
      final response = await http.post(
        Uri.parse(
            'https://vector-calculator-server-968431016.asia-southeast1.run.app/plot'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Check for successful response (HTTP 200)
      if (response.statusCode == 200) {
        // Handle HTML response, the response body is in HTML format
        String responseBody = response.body;

        // Optionally, print the response to the debug console to see the HTML content
        debugPrint('Response: $responseBody');

        // Set the HTML response as the graph content
        setState(() {
          graphHtmlContent = responseBody;
        });
      } else {
        debugPrint('Error: HTTP ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception during HTTP POST: $e');
    }
  }

  List<double>? _parseVector(String input) {
    try {
      return input
          .replaceAll(RegExp(r'[()\s]'), '') // Remove parentheses and spaces
          .split(',')
          .map((e) => double.parse(e))
          .toList();
    } catch (e) {
      debugPrint('Invalid vector format: $input');
      return null; // Return null for invalid input
    }
  }

  Future<void> draw() async {
    debugPrint('Draw button pressed');
    debugPrint('Vectors: $vectors');
    debugPrint('Operations: $operations');
    await getEvaluation(); // Fetch the evaluation results
    await getGraph(); // Fetch the graph
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
                  labelPrefix: 'Vector v',
                  inputHint: 'x,y,z',
                  buttonText: 'ADD VECTOR',
                  onAddItem: addVector,
                  onValueChanged: updateVector,
                ),
                const SizedBox(width: 200),
                // Right side - Operations Section
                RowBuilder(
                  itemCount: operationsCount,
                  labelPrefix: 'Resultant',
                  inputHint: 'v1 + v2',
                  buttonText: 'ADD EXPRESSION',
                  onAddItem: addOperation,
                  onValueChanged: updateOperation,
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
              child: GestureDetector(
                onTap: draw,
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
              ),
            ),
            // GRAPH HERE
            const SizedBox(height: 20),
            // Result text
            Center(
              child: results.isEmpty
                  ? const Text(
                      'No results available yet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var result in results)
                          Text(
                            result,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            // Graph of the result
            graphHtmlContent != null
                ? HtmlWidget(graphHtmlContent!) // Render the HTML content here
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
