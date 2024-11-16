import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/row_builder.dart';

const String serverUrl =
    'https://vector-calculator-server-968431016.asia-southeast1.run.app';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDrawing = false;
  bool _isCalculating = false;

  final String id = (Random().nextInt(900000) + 100000).toString();
  Map<String, bool> expressionSelections = {
    'e1': false,
  };
  Map<String, String> vectors = {
    'v1': '',
  };
  Map<String, String> expressions = {
    'e1': '',
  };
  Map<String, List<double>> results = {};

  void _updateVector(String name, String value) {
    vectors[name] = value;
  }

  void _updateExpression(String name, String value) {
    expressions[name] = value;
  }

  void _addVector() {
    setState(() {
      vectors['v${vectors.length + 1}'] = '';
    });
  }

  void _addExpression() {
    setState(() {
      expressions['e${expressions.length + 1}'] = '';
      expressionSelections['e${expressionSelections.length + 1}'] = false;
    });
  }

  // Function to get the evaluation results from the server
  Future<void> _getEvaluation() async {
    final body = {
      "vectors": vectors.map((key, value) {
        if (value.isEmpty) {
          return MapEntry(key, null);
        } else {
          return MapEntry(key, _parseVectorToList(value));
        }
      }),
      "expressions": expressions.entries
          .map((entry) {
            if (expressionSelections[entry.key] ?? false) {
              return entry.value;
            } else {
              return null;
            }
          })
          .where((element) => element != null)
          .toList(),
    };
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/evaluate'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>?;

        if (jsonResponse != null) {
          setState(() {
            results.clear();
            jsonResponse.forEach((operation, result) {
              if (result == "ERROR") {
                results[operation] = [];
              } else {
                results[operation] = (result as List)
                    .map((e) => double.parse(e.toString()))
                    .toList();
              }
            });
          });
        } else {
          setState(() {
            results = {};
          });
        }
      } else {
        debugPrint('Error: HTTP ${response.statusCode}, ${response.body}');
        setState(() {
          results = {};
        });
      }
    } catch (e) {
      debugPrint('Exception during HTTP POST: $e');
      setState(() {
        results = {};
      });
    }
  }

  Future<void> _getGraph() async {
    final body = {
      "vectors": results,
      "id": id,
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/plot'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
      } else {
        debugPrint('Error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception during HTTP POST: $e');
    }
  }

  List<double>? _parseVectorToList(String input) {
    try {
      return input
          .replaceAll(RegExp(r'[()\s]'), '')
          .split(',')
          .map((e) => double.parse(e))
          .toList();
    } catch (e) {
      debugPrint('Invalid vector format: $input');
      return null;
    }
  }

  Future<void> _onCalculate() async {
    setState(() {
      _isCalculating = true;
    });
    debugPrint('Vectors: $vectors');
    debugPrint('Operations: $expressions');
    await _getEvaluation();
    setState(() {
      _isCalculating = false;
    });
  }

  Future<void> _onDraw() async {
    setState(() {
      _isDrawing = true;
    });
    debugPrint('Results: $results');
    await _getGraph();
    final Uri url = Uri.parse("$serverUrl/get_plot/$id");
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
    setState(() {
      _isDrawing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Vector Calculator',
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
                RowBuilder(
                  data: vectors,
                  inputHint: 'x,y,z',
                  buttonText: 'ADD VECTOR',
                  onAddItem: _addVector,
                  onValueChanged: _updateVector,
                ),
                const SizedBox(width: 200),
                RowBuilder(
                  data: expressions,
                  inputHint: 'v1 + v2',
                  buttonText: 'ADD EXPRESSION',
                  onAddItem: _addExpression,
                  onValueChanged: _updateExpression,
                  hasCheckbox: true,
                  checkboxValues: expressionSelections.values.toList(),
                  onCheckboxChanged: (name, value) {
                    setState(() {
                      expressionSelections[name] = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 70),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            const SizedBox(height: 61),
            !_isCalculating
                ? Center(
                    child: InkWell(
                      onTap: _onCalculate,
                      child: Container(
                        width: 263,
                        height: 66,
                        decoration: BoxDecoration(
                          color: const Color(0xFF66E16C),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "CALCULATE",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            results.isEmpty
                ? const Text(
                    'No results available yet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: results.entries.map((entry) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${entry.key}: ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.value.isEmpty
                                ? 'INVALID INPUT'
                                : entry.value.join(', '),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 20),
            if (results.isNotEmpty)
              !_isDrawing
                  ? Center(
                      child: InkWell(
                        onTap: _onDraw,
                        child: Container(
                          width: 263,
                          height: 66,
                          decoration: BoxDecoration(
                            color: const Color(0xFF66E16C),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              "DRAW GRAPH",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
