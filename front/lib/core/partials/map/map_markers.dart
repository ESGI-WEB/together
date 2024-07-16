import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers extends StatelessWidget {
  final List<LatLng> markers;

  const MapMarkers({super.key, required this.markers});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: markers.map((marker) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: marker,
          child: const Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        );
      }).toList(),
    );
  }
}
