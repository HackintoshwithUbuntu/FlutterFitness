import 'package:flutter/material.dart';

import 'package:runfun/widgets/home/goal_row.dart';
import 'package:runfun/widgets/home/type_row.dart';


class GoalAndTypeContainer extends StatelessWidget {
  const GoalAndTypeContainer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        // Display the Goal Row above
        GoalRow(),
        // Divider Space
        SizedBox(height: 20),
        // Row for selecting the exercise type
        TypeRow(),
      ],
    );
  }
}