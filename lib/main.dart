// import 'dart:html';
import 'dart:ui';
import 'package:flutter/services.dart'; //for using system chrom
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/ch.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   //this will not allow apps orientation to landscape
  //   DeviceOrientation.portraitUp, //will lock the orienrtation to potrate
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          errorColor: Colors.red,
          accentColor: Colors.purple,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                // ignore: deprecated_member_use
                headline1: TextStyle(fontFamily: 'Quicksand', fontSize: 16),
                button: TextStyle(color: Colors.black),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  // ignore: deprecated_member_use
                  headline1: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
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

  void deleteTrans(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showchart = false;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    //to check in which orintation is outr device is
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    //hre we stored appbarr wedgit in a variable beacuse afetr thart we can acces it anywhere and appbar has the information about the
    //height of appbar
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final txwidget = Container(
        height: (mediaquery.size.height -
                appBar.preferredSize.height -
                mediaquery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, deleteTrans));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //in  a List, while using "if" statemnt ,we donrt use{}
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                Switch(
                    //here we assing value:-> showchart,whosa value is set in nchanmged argument
                    value: _showchart,
                    //the new value 'val' will be assinged to showchaartand will be  stored and will tell flutter wether the vslue is true or false
                    onChanged: (val) {
                      //here we use setstate as we are changing the switch and we need the change to be shown no the screen
                      setState(() {
                        _showchart = val;
                      });
                    }), //switch widget shows a switch rtakes bool value and a onchanged parameter
              ],
            ),
          if (!isLandscape)
            Container(
                height: (mediaquery.size.height -
                        appBar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.3, //here chart height is 0.7 because now we are using switch and only chrt or list will be shown at a time
                child: Chart(_recentTransactions)),
          if (!isLandscape) txwidget,

          if (isLandscape)
            _showchart
                ? Container(
                    height: (mediaquery.size.height -
                            appBar.preferredSize.height -
                            mediaquery.padding.top) *
                        0.7, //here chart height is 0.7 because now we are using switch and only chrt or list will be shown at a time
                    child: Chart(_recentTransactions))
                : txwidget,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
