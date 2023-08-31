import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  String currentDropdownValue;
  Color pinColor;
  DropDownWidget(
      {super.key, required this.currentDropdownValue, required this.pinColor});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: widget.currentDropdownValue,
        items: <String>[
          'Qwners',
          'Renter',
          'Paid',
          'Unpaid',
          'kids',
          'Dog',
          'Pool'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              switch (newValue) {
                case 'Qwners':
                  widget.pinColor = Color.fromARGB(255, 4, 95, 7);
                  break;
                case 'Renter':
                  widget.pinColor = Colors.red;
                  break;
                case 'Paid':
                  widget.pinColor = Colors.green;
                  break;
                case 'Unpaid':
                  widget.pinColor = Colors.black38;
                  break;
                case 'kids':
                  widget.pinColor = Colors.black;
                  break;
                case 'Dog':
                  widget.pinColor = Color.fromARGB(255, 82, 51, 40);
                  break;
                case 'Pool':
                  widget.pinColor = Colors.green;
                  break;
                default:
                  widget.pinColor = Colors.blue;
              }
              widget.currentDropdownValue = newValue;
            });
          }
        },
      ),
    );
  }
}
