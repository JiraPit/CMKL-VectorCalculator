import 'package:flutter/material.dart';
import 'package:vector_calculator_desktop/Screens/HomeScreen/components/input_box.dart';

class RowBuilder extends StatelessWidget {
  final int itemCount;
  final String labelPrefix;
  final String inputHint;
  final String buttonText;
  final Function onAddItem;
  final bool hasCheckbox;
  final List<bool>? operationSelections;
  final Function(int, bool?)? onCheckboxChanged;

  const RowBuilder({
    super.key,
    required this.itemCount,
    required this.labelPrefix,
    required this.inputHint,
    required this.buttonText,
    required this.onAddItem,
    this.hasCheckbox = false,
    this.operationSelections,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(itemCount, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$labelPrefix${index + 1}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InputBox(
                        hintText: inputHint,
                      ),
                      if (hasCheckbox)
                        Checkbox(
                          value: operationSelections?[index] ?? false,
                          onChanged: (bool? value) {
                            if (onCheckboxChanged != null) {
                              onCheckboxChanged!(index, value);
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 66),
        GestureDetector(
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
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
