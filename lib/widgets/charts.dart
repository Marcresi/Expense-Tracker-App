import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

   Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, ( sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //Dynamic Adjustment (i.e accc. to size of the Phone) of Height using MediaQuery class.
      height:MediaQuery.of(context).size.height *0.3,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: groupedTransactions.map<Widget>((data) {
              return  totalSpending==0.0 ?  Flexible(
                    fit:FlexFit.tight,
                    child: ChartBar(data['day'], data['amount'] as double ,
                        0.0),
                  ): Flexible(
                    fit:FlexFit.tight,
                    child: ChartBar(data['day'], data['amount'] as double ,
                        (data['amount'] as double) / totalSpending),
                  );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
