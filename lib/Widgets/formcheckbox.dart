import 'package:flutter/material.dart';

class FormCheckBox extends StatefulWidget {
  final String title;
  final bool isChecked;
  final Function(String) onCheckboxChanged;

  FormCheckBox({
    required this.title,
    required this.isChecked,
    required this.onCheckboxChanged,
  });

  @override
  _FormCheckBoxState createState() => _FormCheckBoxState();
}

class _FormCheckBoxState extends State<FormCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: widget.isChecked, // this will determine if checkbox is checked
          onChanged: (newValue) {
            if (newValue!) {
              // Only change if new value is true
              widget.onCheckboxChanged(widget.title);
            }
          },
          activeColor: Colors.blue,
        ),
        Text(widget.title),
      ],
    );
  }
}
