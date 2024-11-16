import 'package:flutter/material.dart';
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/input_box.dart';

class RowBuilder extends StatelessWidget {
  const RowBuilder({
    super.key,
    required this.inputHint,
    required this.buttonText,
    required this.onAddItem,
    required this.onValueChanged,
    this.hasCheckbox = false,
    this.checkboxValues,
    this.onCheckboxChanged,
    required this.data,
  });

  final Map<String, String> data;
  final String inputHint;
  final String buttonText;
  final Function onAddItem;
  final Function(String, String) onValueChanged;
  final bool hasCheckbox;
  final List<bool>? checkboxValues;
  final Function(String, bool?)? onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            data.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.keys.elementAt(index),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InputBox(
                          hintText: inputHint,
                          onValueChanged: (String newValue) {
                            onValueChanged(
                              data.keys.elementAt(index),
                              newValue,
                            );
                          },
                        ),
                        if (hasCheckbox)
                          Checkbox(
                            value: checkboxValues?[index] ?? false,
                            onChanged: (bool? value) {
                              if (onCheckboxChanged != null) {
                                onCheckboxChanged!(
                                  data.keys.elementAt(index),
                                  value,
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 66),
        InkWell(
          onTap: () {
            onAddItem();
          },
          child: Container(
            height: 66,
            width: 263,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC289),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
