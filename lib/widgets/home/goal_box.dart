import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/widgets/home/goal_box_logic.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class GoalBox extends StatefulWidget {
  const GoalBox({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalBox> createState() => _GoalBoxState();
}

class _GoalBoxState extends State<GoalBox> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    // Initialise a controller in initstate so it doesnt get reset on build
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    String goal = notifier.goal;
    // Logic file for the goalbox
    GoalBoxLogic logic = GoalBoxLogic();

    // Clear the text when a new goal type is chosen
    controller.clear();

    return Row(children: <Widget>[
      Expanded(
        // Make the input box
        child: TextField(
          // On change update relevant code
          onChanged: (value) => notifier.setGoalValue(value),
          autocorrect: false,
          // Only enable when a goal is selected
          enabled: logic.goalEnabled(goal),
          // Pull up a number keyboard, with decimal option
          // The number is already unsigned by default
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // Use regex to filter based on goal type selected
            FilteringTextInputFormatter.allow(logic.goalRegex(goal)),
            // Limit input length to 7
            LengthLimitingTextInputFormatter(7),
          ],
          controller: controller,
          //decoration: const InputDecoration(border: OutlineInputBorder()),
        )
      ),
      Text(logic.goalText(goal)),
    ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }
}
