import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../tokens/tokens.dart';
import '../../../core/utils/image_proxy_service.dart';

class ImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroName;
  final String heroTag;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroName,
    required this.heroTag,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void resetZoom() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.reset();
    _animation!.addListener(() {
      _transformationController.value = _animation!.value;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    int heroId = 0;
    try {
      final tagParts = widget.heroTag.split('-');
      if (tagParts.length >= 3) {
        heroId = int.tryParse(tagParts.last) ?? 0;
      }
    } catch (e) {
      // Silently fail
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.heroName,
          style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 24.sp),
            onPressed: resetZoom,
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 5.0,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ImageProxyService.buildImage(
                imageUrl: widget.imageUrl,
                heroName: widget.heroName,
                heroId: heroId,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: SafeArea(
          child: Text(
            'Pinch to zoom • Drag to pan • Tap refresh to reset',
            textAlign: TextAlign.center,
            style: CustomTextStyle.FONT_STYLE_DESCRIPTION
                .copyWith(color: Colors.white70, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}
