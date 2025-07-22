import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/marker.dart';

class MarkerEntityToMarkerMapper {
  static Marker map(MarkerEntity marker,
      {required BitmapDescriptor iconBitmap}) {
    return Marker(
        markerId: MarkerId(marker.id.toString()),
        position: marker.position,
        icon: iconBitmap);
  }
}
