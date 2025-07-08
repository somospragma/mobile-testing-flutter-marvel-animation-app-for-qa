import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerDataModel {
  final int id;
  final LatLng position;
  final BitmapDescriptor? markerUrl;

  MarkerDataModel({required this.id, required this.position, this.markerUrl});

  MarkerDataModel copyWith({
    int? id,
    LatLng? position,
    BitmapDescriptor? markerUrl,
  }) {
    return MarkerDataModel(
      id: id ?? this.id,
      position: position ?? this.position,
      markerUrl: markerUrl ?? this.markerUrl,
    );
  }
}
