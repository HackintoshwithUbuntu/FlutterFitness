import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';
import 'package:runfun/widgets/home/goal_box.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class GoalRow extends StatefulWidget {
  const GoalRow({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalRow> createState() => _GoalRowState();
}

class _GoalRowState extends State<GoalRow> {
  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    // Map icons for easy lookup
    const iconMap = {
      "None": Icon(CustomIcons.none),
      "Distance": Icon(CustomIcons.ruler),
      "Time": Icon(CustomIcons.stopwatch),
      "Steps": Icon(CustomIcons.googleSteps)
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  <Widget>[
        Flexible(
          flex: 3,
          fit: FlexFit.loose,
          child: DropdownMenu<String>(
            // Update selected goal
            onSelected: (value) => notifier.setGoal(value!),
            //  Select the required icon based on goal selection
            leadingIcon: iconMap[notifier.goal],
            initialSelection: notifier.goal,
            label: const Text("Goal Type"),
            dropdownMenuEntries: const [
              DropdownMenuEntry<String>(
                //style: ButtonStyle(alignment: Alignment.centerLeft, padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10))),
                //leadingIcon: Icon(CustomIcons.none),
                value: "None",
                label: "No Goal",
              ),
              DropdownMenuEntry<String>(
                //leadingIcon: Icon(CustomIcons.ruler),
                value: "Distance",
                label: "Distance",
              ),
              DropdownMenuEntry<String>(
                //leadingIcon: Icon(CustomIcons.stopwatch),
                value: "Time",
                label: "Time",
              ),
              DropdownMenuEntry<String>(
                //leadingIcon: Icon(CustomIcons.googlesteps),
                value: "Steps",
                label: "Steps",
              ),
            ]
          ),
        ),
        // Display the input box beside it
        const Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: GoalBox()
        ),
      ]
    );
  }
}
