import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';


class TypeRow extends StatefulWidget {
  const TypeRow({ Key? key }) : super(key: key);

  @override
  State<TypeRow> createState() => _TypeRowState();
}

class _TypeRowState extends State<TypeRow> {
  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    const iconMap = {
      "Run": Icon(CustomIcons.run),
      "Walk": Icon(CustomIcons.walk),
    };
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      DropdownMenu<String>(
        // Set exercise on user select
        onSelected: (value) => notifier.setExercise(value!),
        // Use correct icon
        leadingIcon: iconMap[notifier.exercise],
        initialSelection: notifier.exercise,
        label: const Text("Exercise Type"),
        dropdownMenuEntries: const [
          DropdownMenuEntry<String>(
            value: "Run",
            label: "Run",
          ),
          DropdownMenuEntry<String>(
            value: "Walk",
            label: "Walk",
          ),
        ]
      ),
    ],);
  }
}