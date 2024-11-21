import 'package:cash_denomination/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDenominationDialog extends StatefulWidget {
  final Map<String, String>
      denominationQuantities; // Denomination and their quantities
  final int totalAmount;

  const AddDenominationDialog({
    super.key,
    required this.denominationQuantities,
    required this.totalAmount,
  });

  @override
  _AddDenominationDialogState createState() => _AddDenominationDialogState();
}

class _AddDenominationDialogState extends State<AddDenominationDialog> {
  final TextEditingController _userText = TextEditingController();

  // Dummy data
  List<String> dropdownList = ["General", "Income", "Expenses"];
  String? selectedValue;

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 43, 33, 33),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(width: 1, color: Colors.white)),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text(
                  "Select",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                dropdownColor: Colors.black,
                value: selectedValue,
                items:
                    dropdownList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: _userText,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Fill your remark (if any)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (selectedValue != null && _userText.text.isNotEmpty) {
              await dbHelper.insertRecord({
                "denominationQuantity":
                    widget.denominationQuantities.toString(),
                "totalAmount": widget.totalAmount,
                "dropdownValue": selectedValue!,
                "remark": _userText.text,
              });
              Navigator.of(context).pop(); // Close dialog
            } else {
              // Handle validation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
