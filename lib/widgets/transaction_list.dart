import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;
  TransactionList(this.transaction,this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty?
            LayoutBuilder(
                builder: ( ctx ,constrains){
                  return  Column(
                    children: <Widget>[
                      Text("NO transacions yet!!",
                          style: Theme.of(context).textTheme.title),
                      SizedBox(
                        height:20 ,
                      ),
                      Container(
                        height: constrains.maxHeight*.6,
                        child: Image.asset('assets/images/waiting.png',
                            fit:BoxFit.cover
                        ),),
                    ],
                  );
                }
            )
       : ListView.builder(
          itemBuilder: (ctx, indx) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                  vertical: 8,
              horizontal: 5
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                child: FittedBox(
                  child:Text(
                      '\$${transaction[indx].amount.toStringAsFixed(2)}')
                ),
                ),
                ),


                  title: Text(
                          transaction[indx].title,
                          style: Theme.of(context).textTheme.title,
                        ),
                      subtitle:  Text(
                          DateFormat.yMMMd().format(transaction[indx].date),
                          style: TextStyle(color: Colors.grey),
                        ),

                     trailing:IconButton(icon: Icon(Icons.delete),
                         color: Theme.of(context).errorColor,
                         onPressed: ()=>deleteTx(transaction[indx].id)
                     ),
              ),
            );
          },
          itemCount: transaction.length,
        );
  }
}
