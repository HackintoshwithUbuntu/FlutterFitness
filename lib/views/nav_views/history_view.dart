import 'package:flutter/material.dart';
import 'package:runfun/widgets/history/history_card.dart';

import 'package:runfun/widgets/ui/custom_appbar.dart';
import 'package:runfun/widgets/ui/loader.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    // Load page data and show the loading circle
    notifier.historyPageLoad(_refreshIndicatorKey);
  }

  // A widget to display when there are no previous runs
  Widget emptytext(){
    return Center(
      child: Text(
        "There are no previous runs",
        style: Theme.of(context).textTheme.titleMedium
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return Scaffold(
      // Show loading widget if loading
      body: notifier.loading ? const Loader(text: "History Loading") 
      : RefreshIndicator(
        key: _refreshIndicatorKey,
        // On refresh request data again
        onRefresh: () => notifier.historyPageLoad(_refreshIndicatorKey),
        // If empty show the empty text widget
        child: notifier.emptyHistory ? emptytext() : CustomScrollView(
          slivers: <Widget>[
            CustomSliverAppBar(
              title: Text(
                "History", 
                style: Theme.of(context).textTheme.titleLarge!
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                // Loop through each run and show its information on a card
                <Widget>[
                  for(final Map<String, String> i in notifier.historyRuns) 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HistoryCard(
                      date: i["date"]!, 
                      type: i["type"]!, 
                      fileName: i["fileName"]!, 
                      distance: i["distance"]!, 
                      steps: i["steps"]!, 
                      time: i["time"]!
                    ),
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}