import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class DOBPicker extends StatefulWidget {
  const DOBPicker({
    super.key,
    required this.dobController,
  });
  final TextEditingController dobController;

  @override
  State<DOBPicker> createState() => _DOBPickerState();
}

class _DOBPickerState extends State<DOBPicker> {
  DateTime? selectedDate;
  // TextEditingController dobController = widget.;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.dobController.text = DateFormat('yyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.dobController,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true, // Prevents manual editing
      onTap: () => _selectDate(context),
    );
  }
}
