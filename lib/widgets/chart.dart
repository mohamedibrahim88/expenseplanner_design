import 'package:expenseplanner/models/transaction.dart';
import 'package:expenseplanner/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget{
  final List <Transaction> recentTransaction ;
  Chart (this.recentTransaction);
List <Map<String,Object>>get groubedTransactionVlues {
return List.generate(7, (index)
{
 final weekDay = DateTime.now().subtract(Duration(days:index),);
     double totalamount=0;
     for ( int i =0 ;i <recentTransaction.length;i++){
        if (recentTransaction[i].date.day==weekDay.day &&
            recentTransaction[i].date.month==weekDay.month&&
            recentTransaction[i].date.year==weekDay.year)
        {
          totalamount +=recentTransaction[i].amount;
        }
     }
     //print(DateFormat.E(weekDay));
    // print (totalamount);
return {
       'day':DateFormat.E().format(weekDay).substring(0,1),
        'amount':totalamount
};
});
}
double get totalSpending {
  return groubedTransactionVlues.fold(0.0, (sum, item) {
    return   sum + item['amount'] ;
  } );
}
  Widget build(BuildContext context) {
    return Card(
  elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding (
        padding: EdgeInsets.all(10),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groubedTransactionVlues.map((data){
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending==0.0? 0.0
                      :(data['amount'] as double)/totalSpending,
                ),
            );
          }).toList()
        ),
      ),
    );
  }
}