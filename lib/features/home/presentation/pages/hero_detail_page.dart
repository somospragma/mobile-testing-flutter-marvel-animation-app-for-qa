import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/hero.dart' as hero_entity;
import '../../../../shared/presentation/widgets/power_stats_widget.dart';
import '../../../../shared/presentation/widgets/image_viewer.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../../../core/utils/web_view_service.dart';
import '../state/hero_detail_provider.dart';

class HeroDetailPage extends ConsumerWidget {
  final hero_entity.Hero hero;

  const HeroDetailPage({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the hero detail provider to get complete data from API
    final heroDetailState = ref.watch(heroDetailProvider(hero.id));
    
    // Use the complete hero data if available, otherwise use the basic hero data
    final displayHero = heroDetailState.hero ?? hero;
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                displayHero.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              background: GestureDetector(
                onTap: displayHero.picture.isNotEmpty ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(
                        imageUrl: displayHero.picture,
                        heroName: displayHero.name,
                        heroTag: 'hero-image-${displayHero.id}',
                      ),
                    ),
                  );
                } : null,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    displayHero.picture.isNotEmpty
                        ? Hero(
                            tag: 'hero-image-${displayHero.id}',
                            child: Image.network(
                              displayHero.picture,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderImage(),
                            ),
                          )
                        : _buildPlaceholderImage(),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Basic Info
                  _buildBasicInfoSection(displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // Biography Section
                  if (displayHero.fullName != null || displayHero.publisher != null || displayHero.placeOfBirth != null || displayHero.firstAppearance != null || displayHero.alterEgos != null || displayHero.aliases != null)
                    _buildBiographySection(displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // Appearance Section
                  if (displayHero.gender != null || displayHero.race != null || displayHero.height != null || displayHero.weight != null || displayHero.eyeColor != null || displayHero.hairColor != null)
                    _buildAppearanceSection(displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // Work Section
                  if (displayHero.occupation != null || displayHero.base != null)
                    _buildWorkSection(displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // Connections Section
                  if (displayHero.groupAffiliation != null || displayHero.relatives != null)
                    _buildConnectionsSection(displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // External Link Section
                  _buildExternalLinkSection(context, displayHero),
                  
                  SizedBox(height: 24.h),
                  
                  // Power Stats Section
                  _buildPowerStatsSection(displayHero),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
            ],
          ),
          // Loading indicator overlay
          if (heroDetailState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.person,
          size: 100.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'Basic Information',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayHero.description.isNotEmpty && displayHero.description != 'No Description')
              _buildInfoRow('Description', displayHero.description),
            if (displayHero.alignment != null)
              _buildInfoRow('Alignment', displayHero.alignment!, _getAlignmentColor(displayHero.alignment!)),
          ],
        ),
      ),
    );
  }

  Widget _buildBiographySection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'Biography',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayHero.fullName != null)
              _buildInfoRow('Full Name', displayHero.fullName!),
            if (displayHero.publisher != null)
              _buildInfoRow('Publisher', displayHero.publisher!, Colors.blue),
            if (displayHero.placeOfBirth != null)
              _buildInfoRow('Place of Birth', displayHero.placeOfBirth!),
            if (displayHero.firstAppearance != null)
              _buildInfoRow('First Appearance', displayHero.firstAppearance!),
            if (displayHero.alterEgos != null && displayHero.alterEgos != 'No alter egos found.')
              _buildInfoRow('Alter Egos', displayHero.alterEgos!),
            if (displayHero.aliases != null && displayHero.aliases!.isNotEmpty)
              _buildAliasesRow('Aliases', displayHero.aliases!),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.face,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'Appearance',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayHero.gender != null)
              _buildInfoRow('Gender', displayHero.gender!),
            if (displayHero.race != null)
              _buildInfoRow('Race', displayHero.race!),
            if (displayHero.height != null && displayHero.height!.isNotEmpty)
              _buildListRow('Height', displayHero.height!),
            if (displayHero.weight != null && displayHero.weight!.isNotEmpty)
              _buildListRow('Weight', displayHero.weight!),
            if (displayHero.eyeColor != null)
              _buildInfoRow('Eye Color', displayHero.eyeColor!),
            if (displayHero.hairColor != null)
              _buildInfoRow('Hair Color', displayHero.hairColor!),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkSection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'Work',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayHero.occupation != null)
              _buildInfoRow('Occupation', displayHero.occupation!),
            if (displayHero.base != null)
              _buildInfoRow('Base of Operations', displayHero.base!),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerStatsSection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.red,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Power Statistics',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            PowerStatsWidget(
              intelligence: displayHero.intelligence,
              strength: displayHero.strength,
              speed: displayHero.speed,
              durability: displayHero.durability,
              power: displayHero.power,
              combat: displayHero.combat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomColor.BRAND_GRAY,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                color: valueColor ?? CustomColor.BRAND_PRIMARY_00,
                fontWeight: valueColor != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsSection(hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.group,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'Connections',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (displayHero.groupAffiliation != null)
              _buildInfoRow('Group Affiliation', displayHero.groupAffiliation!),
            if (displayHero.relatives != null)
              _buildInfoRow('Relatives', displayHero.relatives!),
          ],
        ),
      ),
    );
  }

  Widget _buildAliasesRow(String label, List<String> aliases) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomColor.BRAND_GRAY,
            ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: aliases.map((alias) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: CustomColor.BRAND_PRIMARY_01.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: CustomColor.BRAND_PRIMARY_01.withOpacity(0.3)),
              ),
              child: Text(
                alias,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: CustomColor.BRAND_PRIMARY_01,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String label, List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomColor.BRAND_GRAY,
              ),
            ),
          ),
          Expanded(
            child: Text(
              values.join(', '),
              style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                color: CustomColor.BRAND_PRIMARY_00,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlignmentColor(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'good':
        return CustomColor.SUCCESS_COLOR;
      case 'bad':
        return CustomColor.ERROR_COLOR;
      case 'neutral':
        return CustomColor.BRAND_GRAY;
      default:
        return Colors.grey;
    }
  }

  Widget _buildExternalLinkSection(BuildContext context, hero_entity.Hero displayHero) {
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.link,
                  color: CustomColor.BRAND_PRIMARY_01,
                  size: 24.sp,
                ),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(
                  'More Information',
                  style: CustomTextStyle.FONT_STYLE_LABEL.copyWith(
                    color: CustomColor.BRAND_PRIMARY_00,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  WebViewService().openWebView(
                    context,
                    'https://www.marvel.com/comics/characters',
                  );
                },
                icon: Icon(
                  Icons.open_in_browser,
                  color: Colors.white,
                  size: 20.sp,
                ),
                label: Text(
                  'View Marvel Comics Characters',
                  style: CustomTextStyle.FONT_STYLE_BUTTON.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.BRAND_PRIMARY_01,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.SPACE_M.w,
                    vertical: Spacing.SPACE_S.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
