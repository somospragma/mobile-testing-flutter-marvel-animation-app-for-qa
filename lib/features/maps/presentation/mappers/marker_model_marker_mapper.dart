import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/models/marker_model.dart';

class MarkerModelToMarker {
  static Marker map(MarkerModel marker) {
    return Marker(
      markerId: MarkerId(marker.id.toString()),
      position: marker.position,
      icon: marker.markerUrl ?? BitmapDescriptor.defaultMarker
    );
  }
}
