import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageProxyService {
  static String _getProxiedImageUrl(String originalUrl) {
    if (originalUrl.isEmpty || !originalUrl.startsWith('http') || !originalUrl.contains('superherodb.com')) {
      return originalUrl;
    }
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(originalUrl)}';
  }

  static String _generateAvatarUrl(String heroName, int heroId) {
    final parts = heroName.split(RegExp(r'[ -]')).where((s) => s.isNotEmpty);
    final initials = parts.length > 1
        ? parts.map((p) => p[0].toUpperCase()).take(2).join()
        : (heroName.isNotEmpty ? heroName[0].toUpperCase() : '?');
    final colorHex = _getColorForId(heroId, asHex: true);
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(initials)}&background=$colorHex&color=fff&size=256&bold=true&format=png';
  }

  static dynamic _getColorForId(int id, {bool asHex = false}) {
    final colors = ['3498db', '2ecc71', 'e74c3c', '9b59b6', 'f39c12', '1abc9c', 'c0392b', '8e44ad'];
    final hex = colors[id % colors.length];
    return asHex ? hex : Color(int.parse('0xFF$hex'));
  }

  static Widget buildImage({
    required String imageUrl,
    required String heroName,
    required int heroId,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    final proxiedUrl = _getProxiedImageUrl(imageUrl);

    final Widget shimmerPlaceholder = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(width: width, height: height, color: Colors.white),
    );

    return CachedNetworkImage(
      imageUrl: proxiedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => shimmerPlaceholder,
      // SOLUCIÓN: Hace que la transición del placeholder a la imagen sea instantánea.
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      errorWidget: (context, url, error) => _buildAvatar(
        heroName: heroName,
        heroId: heroId,
        fit: fit,
        width: width,
        height: height,
        placeholder: shimmerPlaceholder,
      ),
    );
  }

  static Widget _buildAvatar({
    required String heroName,
    required int heroId,
    required BoxFit fit,
    required double? width,
    required double? height,
    required Widget placeholder,
  }) {
    final avatarUrl = _generateAvatarUrl(heroName, heroId);
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder,
      // SOLUCIÓN: Hace que la transición del placeholder al avatar sea instantánea.
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: _getColorForId(heroId),
        child: const Center(child: Icon(Icons.shield_moon, color: Colors.white, size: 48)),
      ),
    );
  }
}
