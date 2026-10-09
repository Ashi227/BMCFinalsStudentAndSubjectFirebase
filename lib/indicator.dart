import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int activeStep;

  const StepIndicator({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StepItem(number: 1, name: 'Details', isActive: activeStep == 1),
        StepItem(number: 2, name: 'Subjects', isActive: activeStep == 2),
        StepItem(number: 3, name: 'Review', isActive: activeStep == 3),
      ],
    );
  }
}

class StepItem extends StatelessWidget {
  final int number;
  final String name;
  final bool isActive;

  const StepItem({
    super.key,
    required this.number,
    required this.name,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}