import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_data_model.dart';
import '../../domain/entities/marker.dart';

class MarkerDataMapper {
  static MarkerDataModel fromJsonToModel(Map<String, dynamic> json) {
    return MarkerDataModel(
      id: json["id"],
      position: LatLng(json["latitude"], json["longitude"]),
    );
  }

  static MarkerEntity fromModelToEntity(MarkerDataModel model) {
    return MarkerEntity(
      id: model.id,
      position: model.position,
    );
  }
}
