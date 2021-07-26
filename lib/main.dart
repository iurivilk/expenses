import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses/models/transaction.dart';
import 'dart:math';
//import 'package:flutter/services.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showGraphics = true;
  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        title: 'Shoes',
        value: 300.99,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: '2',
        title: 'Pants',
        value: 200.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: '3',
        title: 'Glasses',
        value: 499.99,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: '4',
        title: 'Jacket',
        value: 550.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(id: '5', title: 'Cap', value: 100.99, date: DateTime.now()),
    Transaction(id: '6', title: 'Guitar', value: 1000.99, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        if(isLandscape)
        IconButton(
          icon: Icon(_showGraphics ? Icons.list : Icons.show_chart),
          onPressed: () {
            setState(() {
              _showGraphics = !_showGraphics;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show graphics'),
                  Switch(value: _showGraphics, onChanged: (value) {
                    setState(() {
                      _showGraphics = value;
                    });
                  }),
                ],
              ),
              if (_showGraphics || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 0.8 : (0.30)),
                  child: (Chart(_recentTransactions))),
              if (!_showGraphics || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 1 : (0.7)),
                  child: TransactionList(_transactions, _removeTransaction)),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
