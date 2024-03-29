import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String lable;
  final double spendingAmount;
  final double spendingPctOfTotal;
  ChartBar(this.lable, this.spendingAmount, this.spendingPctOfTotal);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      /*here ctx and constraint are provided by fluitter where ctx is context */
      return Column(
        /*and constrains have the information about the constraints of its parents*/
        children: [
          /*CONSTRAIONS MEANS THE AMOUNT OG HEIGHT AND WIDTH THE WIDGET TAkes */
          Container(
              height: constraint.maxHeight * .15,
              /*we can use constrsins to define height amd width ,here we use it to  */
              child: FittedBox(
                  /*define height maxHeight give the max. amount of the height the widget can take */
                  child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraint.maxHeight * .05,
          ),
          Container(
            height: constraint.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                )),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * .05,
          ),
          Container(
              height: constraint.maxHeight * .15,
              child: FittedBox(child: Text(lable))),
        ],
      );
    });
  }
}
