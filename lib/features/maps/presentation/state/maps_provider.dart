import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/entities/marker.dart';
import '../../domain/usecases/maps_usecase.dart';
import '../mappers/marker_entity_to_marker_mapper.dart';
import 'maps_state.dart';

final mapsProvider =
    NotifierProvider<MapsNotifier, MapsState>(() => MapsNotifier());

class MapsNotifier extends Notifier<MapsState> {
  late final MapsUsecase mapsUsecase;

  @override
  MapsState build() {
    mapsUsecase = ref.read(mapsUsecaseProvider);
    return MapsState();
  }

  void cleanAlert() {
    state = state.copyWith();
  }

  Future<void> getLocation() async {
    state = state.copyWith(isLoading: true);

    final Either<Failure, MarkerEntity?> response =
        await mapsUsecase.getLocation();
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
          alert: AlertModel(
              message: left.errorMessage,
              backgroundColor: CustomColor.ERROR_COLOR));
    }, (MarkerEntity? right) async {
      if (right != null) {
        AssetMapBitmap markerImageUrl = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(70, 70)),
          'assets/marker.png',
        );
        final Marker marker =
            MarkerEntityToMarkerMapper.map(right, iconBitmap: markerImageUrl);
        state = state.copyWith(location: {marker});
      }
    });
  }
}
