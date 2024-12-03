import 'package:flutter/material.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

import 'package:rive/rive.dart';

class HistoryFilledIcon extends StatefulWidget {
  const HistoryFilledIcon({Key? key}) : super(key: key);

  @override
  State<HistoryFilledIcon> createState() => _HistoryFilledIconState();
}

class _HistoryFilledIconState extends State<HistoryFilledIcon> {
  late RiveAnimation icon;

  @override
  void initState() {
    super.initState();
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    if (notifier.isDarkMode) {
      icon = const RiveAnimation.asset('assets/historyanimateddark.riv', fit: BoxFit.fill);
    } else {
      icon = const RiveAnimation.asset('assets/historyanimated.riv', fit: BoxFit.fill);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      // Use the Rive animation on click
      child: icon
    );
  }
}