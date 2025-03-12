import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_animation_app/shared/presentation/templates/main_template.dart';

import '../../../../shared/presentation/pages/loading_page.dart';
import '../../../../shared/presentation/tokens/spacing.dart';
import '../state/maps_provider.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({
    super.key,
  });
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  late GoogleMapController mapController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapsProvider.notifier).getLocation();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapsNotifier = ref.watch(mapsProvider);
    if (mapsNotifier.isLoading) {
      return const LoadingPage();
    }

    return MainTemplate(
      onBack: () => Navigator.pop(context),
      horizontalPadding: Spacing.NO_SPACE,
      hasScroll: false,
      body: GoogleMap(
        markers: mapsNotifier.location ?? {},
        initialCameraPosition: CameraPosition(
          target: mapsNotifier.location?.first.position ??
              const LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
      ),
    );
  }
}
