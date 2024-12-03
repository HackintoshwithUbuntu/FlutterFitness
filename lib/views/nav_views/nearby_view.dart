import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/widgets/nearby/nearby_card.dart';
import 'package:runfun/widgets/ui/loader.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyView extends StatefulWidget {
  const NearbyView({super.key});

  @override
  State<NearbyView> createState() => _NearbyViewState();
}

class _NearbyViewState extends State<NearbyView> {
  // Map Style storage variables
  late String _darkMapStyle;
  late String _lightMapStyle;

  // Future for future builder
  late Future<double> _data;

  // Function to load map styles
  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/mapstyles/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/mapstyles/light.json');
  }

  // Marker Icon storage variable
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  // Function to set marker assets
  void addMarkers() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/runMarker.png'
    ).then((d) {
      setState(() {
        markerIcon = d;
      });
    });
  }

  Timer? timer;
  Set<Marker> markerSet = {};

  @override
  void initState() {
    super.initState();
    // Load in map styles
    _loadMapStyles();
    // Load in the marker files
    addMarkers();
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);

    // Function to update markers, it needs to be called before use in the timer
    // so it gets its own function 
    Future<void> updateMarkers() async {
      // Update nearby user info within the notifier
      await notifier.updateNearby();
      // Generate a list of markers with the info and then convert to set, to 
      // make Google Maps happy
      markerSet = List.generate(notifier.nearbyUnames.length, (index){
        return Marker(
          markerId: MarkerId("$index"),
          position: LatLng(
            notifier.nearbyLats[index], 
            notifier.nearbyLongs[index],
          ),
          // Add the icon
          icon: markerIcon,
          // On tap update data and set widget state
          onTap: () {
            notifier.updateNearbyShown(notifier.nearbyUnames[index], true);
            setState(() {});
          }
        );
      }).toSet();
      // Tell the Widget to update its state
      setState(() {});
      return;
    }

    // Call once on load before scheduling
    updateMarkers();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await updateMarkers();
      notifier.updateNearbyShown("", false);
    });

    // Check that we have a non null location to set the map to
    _data = notifier.getNonNullLatLong();
  }


  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Users", 
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader(text: "Loading Nearby");
          } else {
            return Column(
              children: [
                Expanded(
                  // Use a stack since the card needs to come on top of the map
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        // Curve edges of map to look modern
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(notifier.lastLat!, notifier.lastLong!),
                              zoom: 14.0
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            markers: markerSet,
                            // Add the style on map created
                            onMapCreated: (GoogleMapController controller) {
                              if(notifier.isDarkMode){
                                controller.setMapStyle(_darkMapStyle);
                              } else {
                                controller.setMapStyle(_lightMapStyle);
                              }
                            }
                          ),
                        ),
                      ),
                      // Show the nearby card if required
                      notifier.showNearbyCard
                        ? NearbyCard(notifier: notifier) 
                        : const SizedBox.shrink()
                    ],
                  ),
                ),
              ],
            );//;
          }
        }
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the nearby refresh on widget destruction
    timer?.cancel();
    super.dispose();
  }
}