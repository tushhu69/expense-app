import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleTx;

  TransactionList(this.transactions, this.deleTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        //here we use layoutbuilder becausae it gives us 'constraints' which can be used to define height dinammically
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                // ignore: deprecated_member_use
                Text(
                  'Nothing added yet!!!!',
                  // ignore: deprecated_member_use
                  style: TextStyle(
                    color: Color.fromARGB(255, 170, 57, 57),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                  height: constraints.maxHeight * .6,
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                          child: Text('\$${transactions[index].amount}')),
                    ),
                  ),
                  title: Text(transactions[index].title,
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.headline1),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          onPressed: () => deleTx(transactions[index].id),
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          textColor: Theme.of(context).errorColor,
                        )
                      : IconButton(
                          color: Theme.of(context).errorColor,
                          icon: Icon(Icons.delete),
                          onPressed: () => deleTx(transactions[index].id)),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
