import 'package:flutter/material.dart';

import 'package:runfun/widgets/settings/countries_view.dart';
import 'package:runfun/widgets/settings/name_modal.dart';

import 'package:runfun/widgets/settings/settings_label.dart';
import 'package:runfun/widgets/ui/custom_listtile.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class UserTiles extends StatefulWidget {
  const UserTiles({super.key});

  @override
  State<UserTiles> createState() => _UserTilesState();
}

class _UserTilesState extends State<UserTiles> {
  void openNameModal(bool isFname) {
    showModalBottomSheet(
      context: context,
      builder: (context) => NameModal(isFname: isFname),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.ltr,
      children: [
        const SettingsLabel(text: "User Settings"),
        // Change firs tand last name, they call same function with paramter
        CustomListTile(
          title: "First Name",
          subtitle: "Change your first name",
          onTap: () => openNameModal(true),
        ),
        CustomListTile(
          title: "Last Name",
          subtitle: "Change your last name",
          onTap: () => openNameModal(false),
        ),
        // Change country
        CustomListTile(
          title: "Country",
          subtitle: "Change your country selection",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CountriesView()),
            );
          },
        ),
        // Stop sending location updates switcher
        CustomListTile(
          title: "Location Updates",
          subtitle: "Update the nearby map with your location",
          trailing: Switch(
            value: notifier.settingsLocation,
            onChanged: (_) => notifier.stopTracking(),
          ),
        ),
      ],
    );
  }
}
