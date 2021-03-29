import 'package:flutter/cupertino.dart';
import './widgets/chart.dart';
import 'dart:io';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "ExpensePlanner",
      theme: ThemeData(
        primarySwatch:Colors.purple,
        accentColor: Colors.amberAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20
          )
        ),
          appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20
            )
          )
      ),
      ),


      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 final List<Transaction> _userTransaction = [
  //  Transaction(id: "t", title: "shoes", amount: 99.9, date: DateTime.now()),
    //Transaction(id: "t2", title: "koory", amount: 15.9, date: DateTime.now()),
  ];
 bool _showChart=false ;
 List <Transaction> get _recentTransaction{
   return _userTransaction.where((tx) {
     return tx.date.isAfter(DateTime.now().subtract(Duration(days:7)
     )
     );
   }).toList();
 }
  void _addNewTransaction(String txtitle, double txamount , DateTime chosenDate) {
    final newtx = Transaction(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: txamount,
        date: chosenDate,
    );
    setState(() {
      _userTransaction.add(newtx);
    });
  }
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
  void _deleteTransaction (String id){
   setState(() {
     _userTransaction.removeWhere((tx) => tx.id==id);
   });
  }
 List <Widget> _buildLandscapContent(MediaQueryData mediaQuery ,AppBar appBar,
     Widget txListWidget
     ) {
   return[
     Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children:<Widget> [
         Text('Show Chart',style: Theme.of(context).textTheme.title,),
         Switch.adaptive(
             activeColor: Theme.of(context).accentColor,
             value: _showChart, onChanged: (val) {
           setState(() {
             _showChart=val;
           });
         })
       ],
     ),
     _showChart?
     Container(
       height: (mediaQuery.size.height-mediaQuery.padding.top-
           appBar.preferredSize.height)*.7,
       child: Chart (_recentTransaction),
     )
         :txListWidget,
   ];
 }
 List<Widget> _buildPortraitContent(
     MediaQueryData mediaQuery,
     AppBar appBar,
     Widget txListWidget,
     ) {
   return [
     Container(
       height: (mediaQuery.size.height -
           appBar.preferredSize.height -
           mediaQuery.padding.top) *
           0.3,
       child: Chart(_recentTransaction),
     ),
     txListWidget
   ];
 }
Widget _buildAppBar (){
   return Platform.isIOS?
   CupertinoNavigationBar(
     middle: Text('personal Expense'),
     trailing: Row(
       mainAxisSize: MainAxisSize.min,
       children:<Widget> [
         GestureDetector(
           child: Icon (CupertinoIcons.add),
           onTap: ()=>_startAddNewTransaction(context),
         )
       ],
     ),
   )
       : AppBar(
     title: Text ('Personel Epenses'),
     actions:<Widget> [
       IconButton(icon: Icon(Icons.add),
           onPressed: ()=>_startAddNewTransaction(context))
     ],
   );
}
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation==Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height-appBar.preferredSize.height-
          mediaQuery.padding.top)*.7,
      child: TransactionList(_userTransaction,_deleteTransaction),
    );
        final pageBody =SafeArea(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
              ...  _buildLandscapContent(mediaQuery, appBar, txListWidget),
                if (!isLandscape)
                ...  _buildPortraitContent(mediaQuery, appBar, txListWidget)
            ],
          ),
        ),
        );
    return Platform.isIOS?
    CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
    )
    :
        Scaffold(
          appBar: appBar,
          body: pageBody,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Platform.isIOS?
          Container()
          :
              FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: ()=>_startAddNewTransaction(context),
        )
    );
  }
}

