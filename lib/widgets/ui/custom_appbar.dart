import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  // Use a widget title rather than a string to allow different styles of text
  // to use the same appbar widget
  final Widget title;
  final bool showBack;

  // Set not showing the back button as default unless specified
  const CustomSliverAppBar(
    {super.key, required this.title, this.showBack = false}
  );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: showBack ? null : 100.0,
      // Stop a back button from appearing, unless specified
      automaticallyImplyLeading: showBack,
      // Space things out a little
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          bottom: 14.0,
          left: showBack ? 48.0 : 16.0,
        ),
        // Pass through the title
        title: title,
      ),
      //MaterialStateColor.resolveWith(
      //(states) => states.contains(MaterialState.scrolledUnder)
      //? Theme.of(context).colorScheme.surface
      //: Theme.of(context).canvasColor,
      //),
    );
  }
}
