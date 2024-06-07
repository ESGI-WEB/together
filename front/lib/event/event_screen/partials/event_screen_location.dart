import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front/core/partials/map/map_markers.dart';
import 'package:front/core/partials/map/map_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class EventScreenLocation extends StatelessWidget {
  final LatLng localisation;

  const EventScreenLocation({super.key, required this.localisation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: localisation,
          initialZoom: 16,
        ),
        children: [
          const MapTileLayer(),
          MapMarkers(markers: [
            localisation,
          ]),
        ],
      ),
    );
  }
}
