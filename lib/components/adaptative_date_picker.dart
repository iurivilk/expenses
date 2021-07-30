import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  AdaptativeDatePicker({this.selectedDate, this.onDateChanged});

  _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        //Platform.isIOS ? Container(height: 180, child: CupertinoDatePicker(mode: CupertinoDatePickerMode.date,
        // initialDateTime: DateTime.now(), minimumDate: DateTime(2020), maximumDate: DateTime.now(),
        // onDateTimeChanged: onDateChanged)) :
        Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(selectedDate == null
                ? 'No date selected'
                : 'Date: ' + DateFormat('d/MM/y').format(selectedDate)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () => _showDatePicker(context),
              child: Text(
                'Select date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
