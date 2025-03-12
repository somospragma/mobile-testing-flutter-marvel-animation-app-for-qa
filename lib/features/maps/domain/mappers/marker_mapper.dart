import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/marker_model.dart';

class MarkerMapper {
  static MarkerModel fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json["id"],
      position: LatLng(json["latitude"], json["longitude"]),
    );
  }

}
