import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/hero.dart' as hero_entity;
import '../../../../shared/presentation/widgets/power_stats_widget.dart';
import '../../../../shared/presentation/widgets/image_viewer.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../../../core/utils/web_view_service.dart';
import '../../../../core/utils/image_proxy_service.dart';
import '../state/hero_detail_provider.dart';

class HeroDetailPage extends ConsumerWidget {
  final hero_entity.Hero hero;

  const HeroDetailPage({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroDetailState = ref.watch(heroDetailProvider(hero.id));
    final displayHero = heroDetailState.value?.hero ?? hero;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                    onTap: displayHero.picture.isNotEmpty
                        ? () {
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
                          }
                        : null,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'hero-image-${displayHero.id}',
                          child: ImageProxyService.buildImage(
                            imageUrl: displayHero.picture,
                            heroName: displayHero.name,
                            heroId: displayHero.id,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(displayHero),
                      SizedBox(height: 24.h),
                      if (displayHero.fullName != null ||
                          displayHero.publisher != null)
                        _buildBiographySection(displayHero),
                      SizedBox(height: 24.h),
                      if (displayHero.gender != null ||
                          displayHero.race != null)
                        _buildAppearanceSection(displayHero),
                      SizedBox(height: 24.h),
                      if (displayHero.occupation != null ||
                          displayHero.base != null)
                        _buildWorkSection(displayHero),
                      SizedBox(height: 24.h),
                      if (displayHero.groupAffiliation != null ||
                          displayHero.relatives != null)
                        _buildConnectionsSection(displayHero),
                      SizedBox(height: 24.h),
                      _buildExternalLinkSection(context, displayHero),
                      SizedBox(height: 24.h),
                      _buildPowerStatsSection(displayHero),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildBasicInfoSection(hero_entity.Hero hero) {
    return _buildSectionCard(
      icon: Icons.info_outline,
      title: 'Basic Information',
      children: [
        if (hero.description.isNotEmpty && hero.description != 'No Description')
          _buildInfoRow('Description', hero.description),
        if (hero.alignment != null)
          _buildInfoRow('Alignment', hero.alignment!,
              _getAlignmentColor(hero.alignment!)),
      ],
    );
  }

  Widget _buildBiographySection(hero_entity.Hero hero) {
    return _buildSectionCard(
      icon: Icons.person_outline,
      title: 'Biography',
      children: [
        if (hero.fullName != null) _buildInfoRow('Full Name', hero.fullName!),
        if (hero.publisher != null)
          _buildInfoRow('Publisher', hero.publisher!, Colors.blue),
        if (hero.placeOfBirth != null)
          _buildInfoRow('Place of Birth', hero.placeOfBirth!),
        if (hero.firstAppearance != null)
          _buildInfoRow('First Appearance', hero.firstAppearance!),
        if (hero.alterEgos != null && hero.alterEgos != 'No alter egos found.')
          _buildInfoRow('Alter Egos', hero.alterEgos!),
        if (hero.aliases != null && hero.aliases!.isNotEmpty)
          _buildAliasesRow('Aliases', hero.aliases!),
      ],
    );
  }

  Widget _buildAppearanceSection(hero_entity.Hero hero) {
    return _buildSectionCard(
      icon: Icons.face,
      title: 'Appearance',
      children: [
        if (hero.gender != null) _buildInfoRow('Gender', hero.gender!),
        if (hero.race != null) _buildInfoRow('Race', hero.race!),
        if (hero.height != null && hero.height!.isNotEmpty)
          _buildListRow('Height', hero.height!),
        if (hero.weight != null && hero.weight!.isNotEmpty)
          _buildListRow('Weight', hero.weight!),
        if (hero.eyeColor != null) _buildInfoRow('Eye Color', hero.eyeColor!),
        if (hero.hairColor != null)
          _buildInfoRow('Hair Color', hero.hairColor!),
      ],
    );
  }

  Widget _buildWorkSection(hero_entity.Hero hero) {
    return _buildSectionCard(
      icon: Icons.work_outline,
      title: 'Work',
      children: [
        if (hero.occupation != null)
          _buildInfoRow('Occupation', hero.occupation!),
        if (hero.base != null) _buildInfoRow('Base of Operations', hero.base!),
      ],
    );
  }

  Widget _buildConnectionsSection(hero_entity.Hero hero) {
    return _buildSectionCard(
      icon: Icons.group,
      title: 'Connections',
      children: [
        if (hero.groupAffiliation != null)
          _buildInfoRow('Group Affiliation', hero.groupAffiliation!),
        if (hero.relatives != null) _buildInfoRow('Relatives', hero.relatives!),
      ],
    );
  }

  Widget _buildPowerStatsSection(hero_entity.Hero hero) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.red, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Power Statistics',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            PowerStatsWidget(
              intelligence: hero.intelligence,
              strength: hero.strength,
              speed: hero.speed,
              durability: hero.durability,
              power: hero.power,
              combat: hero.combat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExternalLinkSection(
    BuildContext context,
    hero_entity.Hero hero,
  ) {
    return _buildSectionCard(
      icon: Icons.link,
      title: 'More Information',
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => WebViewService()
                .openWebView(context, 'https://www.superherodb.com/'),
            icon: Icon(Icons.open_in_browser, color: Colors.white, size: 20.sp),
            label: Text('View on SuperHeroDB',
                style: CustomTextStyle.FONT_STYLE_BUTTON
                    .copyWith(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.BRAND_PRIMARY_01,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: Spacing.SPACE_M.w, vertical: Spacing.SPACE_S.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    if (children.where((c) => c is! SizedBox).isEmpty)
      return const SizedBox.shrink();
    return Card(
      elevation: 2,
      color: CustomColor.BRAND_PRIMARY_02,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(Spacing.SPACE_M.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CustomColor.BRAND_PRIMARY_01, size: 24.sp),
                SizedBox(width: Spacing.SPACE_XS.w),
                Text(title,
                    style: CustomTextStyle.FONT_STYLE_LABEL
                        .copyWith(color: CustomColor.BRAND_PRIMARY_00)),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
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
            child: Text('$label:',
                style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomColor.BRAND_GRAY)),
          ),
          Expanded(
            child: Text(value,
                style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                    color: valueColor ?? CustomColor.BRAND_PRIMARY_00,
                    fontWeight: valueColor != null
                        ? FontWeight.w500
                        : FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  Widget _buildAliasesRow(String label, List<String> aliases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:',
            style: CustomTextStyle.FONT_STYLE_DESCRIPTION.copyWith(
                fontWeight: FontWeight.w600, color: CustomColor.BRAND_GRAY)),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 4.h,
          children: aliases
              .map((alias) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: CustomColor.BRAND_PRIMARY_01.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: CustomColor.BRAND_PRIMARY_01.withOpacity(0.3)),
                    ),
                    child: Text(alias,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: CustomColor.BRAND_PRIMARY_01,
                            fontWeight: FontWeight.w500)),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildListRow(String label, List<String> values) {
    return _buildInfoRow(label, values.join(', '));
  }

  Color _getAlignmentColor(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'good':
        return CustomColor.SUCCESS_COLOR;
      case 'bad':
        return CustomColor.ERROR_COLOR;
      default:
        return CustomColor.BRAND_GRAY;
    }
  }
}
