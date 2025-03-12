import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final int id;
  final LatLng position;
  final BitmapDescriptor? markerUrl;

  MarkerModel({required this.id, required this.position, this.markerUrl});

  MarkerModel copyWith({
    int? id,
    LatLng? position,
    BitmapDescriptor? markerUrl,
  }) {
    return MarkerModel(
      id: id ?? this.id,
      position: position ?? this.position,
      markerUrl: markerUrl ?? this.markerUrl,
    );
  }
}
