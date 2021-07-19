import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double total = 0.0;

      for(var i = 0; i < recentTransactions.length; i++){
        bool sameDay = recentTransactions[i].date.month == weekDay.month;
        bool sameMonth = recentTransactions[i].date.day == weekDay.day;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if(sameDay && sameMonth && sameYear){
          total += recentTransactions[i].value;
        }
      }

      return {'day': DateFormat.E().format(weekDay)[0], 'value': total};
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupedTransactions.map((tr){
          return Text('${tr['day']}: ${tr['value']}:');
        }).toList(),
      ),
    );
  }
}
