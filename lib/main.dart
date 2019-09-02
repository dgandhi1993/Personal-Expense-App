import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amberAccent,
          // fontFamily: 'Mont',
          textTheme: TextTheme(
            body1: TextStyle(fontWeight: FontWeight.w300),
            body2: TextStyle(fontWeight: FontWeight.normal),
            button: TextStyle(
              color: Colors.white,
            ),
          ),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  title: TextStyle(
            fontFamily: 'Mont',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final List<Transaction> transactions = [];

  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 70,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 20,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((txn) {
      return txn.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: txDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((txn) => txn.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {_startAddNewTransaction(context);
                  print("Here");},
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text("Personal Expenses"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    final txnList = Container(
      child: TransactionList(_userTransactions, _deleteTransaction),
      height: (mediaQuery.size.height -
              mediaQuery.padding.top -
              appBar.preferredSize.height) *
          (0.7),
    );
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            isLandscape
                ? Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Show Chart"),
                          Switch.adaptive(
                            activeColor: Theme.of(context).accentColor,
                            value: _showChart,
                            onChanged: (val) {
                              setState(() {
                                _showChart = val;
                              });
                            },
                          )
                        ],
                      ),
                      _showChart
                          ? Container(
                              child: Chart(_recentTransactions),
                              height: (mediaQuery.size.height -
                                      mediaQuery.padding.top -
                                      appBar.preferredSize.height) *
                                  (0.7),
                            )
                          : txnList
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        child: Chart(_recentTransactions),
                        height: (mediaQuery.size.height -
                                mediaQuery.padding.top -
                                appBar.preferredSize.height) *
                            (0.3),
                      ),
                      txnList
                    ],
                  ),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
