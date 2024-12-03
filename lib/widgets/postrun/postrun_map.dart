import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostrunMap extends StatefulWidget {
  final List<double> lats;
  final List<double> longs;
  final List<LatLng> locationData;

  PostrunMap({super.key, required this.lats, required this.longs})
      : locationData = List.generate(lats.length, (index) {
          return LatLng(lats[index], longs[index]);
        });

  @override
  State<PostrunMap> createState() => _PostrunMapState();
}

class _PostrunMapState extends State<PostrunMap> {
  // Map Style storage variables
  late String _darkMapStyle;
  late String _lightMapStyle;

  // Function to load map styles
  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/mapstyles/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/mapstyles/light.json');
  }
  
  // Define the custom markers
  BitmapDescriptor startMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endMarker = BitmapDescriptor.defaultMarker;

  // Function to set marker assets
  void addMarkers() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/locationStart.png'
    ).then((d) {
      setState(() {
        startMarker = d;
      });
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/googleFinish.png'
    ).then((d) {
      setState(() {
        endMarker = d;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the add markers function
    addMarkers();
    // Load in map styles
    _loadMapStyles();
  }

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 14.0),
      child: AspectRatio(
        aspectRatio: 1.25, // Width is 1.25x height
        // Curve the edges of the map
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: GoogleMap(
            // Set initial camera position to start of run and zoom out
            initialCameraPosition: CameraPosition(
              target: widget.locationData.first,
              zoom: 15.5,
            ),
            // Override scrolling gesture detection
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()),
            },
            // Add line with the map run coordinates
            polylines: {
              Polyline(
                polylineId: const PolylineId("main"),
                points: widget.locationData,
                //color:
                //width:
              )
            },
            // Start and finish markers
            markers: {
              Marker(
                markerId: const MarkerId("start"),
                position: widget.locationData.first,
                icon: startMarker
              ),
              Marker(
                markerId: const MarkerId("end"),
                position: widget.locationData.last,
                icon: endMarker
              ),
            },
            // Apply dark / light mode styling when ready
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
    );
  }
}
