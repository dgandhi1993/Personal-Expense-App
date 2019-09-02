import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String weekDay;
  final double amount;
  final double percentageOfTotal;

  ChartBar({this.amount, this.percentageOfTotal, this.weekDay});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight*0.15,
              child: FittedBox(child: Text('\$${amount.toStringAsFixed(0)}')),
            ),
            SizedBox(
              height: constraints.maxHeight*0.05,
            ),
            Container(
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentageOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight*0.05,
            ),
            Container(
              height: constraints.maxHeight*0.15,
              child: FittedBox(
                child: Text(weekDay),
              ),
            )
          ],
        );
      },
    );
  }
}
