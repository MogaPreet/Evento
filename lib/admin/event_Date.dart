import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class DateTimeEvent extends StatefulWidget {
  const DateTimeEvent({Key? key}) : super(key: key);

  @override
  State<DateTimeEvent> createState() => _DateTimeEventState();
}

class _DateTimeEventState extends State<DateTimeEvent> {
  String _selectedDate = '';

  String _dateCount = "";
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} '
            '- ${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
        if (args.value.startDate == args.value.endDate) {
          _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} ';
        }
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        int _dateCount = args.value.toString().length;
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select date"),
      ),
      body: Column(
        children: [
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            enablePastDates: false,
            initialSelectedRange: PickerDateRange(
                DateTime.now().subtract(const Duration(days: 4)),
                DateTime.now().add(const Duration(days: 3))),
          ),
          Text('Selected Date: $_range'),
        ],
      ),
    );
  }
}
