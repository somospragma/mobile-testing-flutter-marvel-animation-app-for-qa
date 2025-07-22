import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerEntity {
  final int id;
  final LatLng position;

  MarkerEntity({
    required this.id,
    required this.position,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          position == other.position;

  @override
  int get hashCode => id.hashCode ^ position.hashCode;
}
