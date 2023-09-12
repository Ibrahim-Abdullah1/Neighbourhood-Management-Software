import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String title;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox(
      {required this.title,
      required this.color,
      required this.value,
      required this.onChanged});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool currentValue = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: currentValue,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  currentValue = value;
                });
                widget.onChanged(value);
              }
            },
            activeColor: widget.color,
          ),
          Text(widget.title),
        ],
      ),
    );
  }
}
