import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/domain/models/error_model.dart';

class MapsState {

  MapsState({
    this.location,
    this.isLoading = false,
    this.alert,
  });
  final Set<Marker>? location;
  final bool isLoading;
  final AlertModel? alert;

  MapsState copyWith({
    Set<Marker>? location,
    bool? isLoading,
    AlertModel? alert,
  }) {
    return MapsState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
    );
  }
}
