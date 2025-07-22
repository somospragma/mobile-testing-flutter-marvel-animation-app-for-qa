import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../features/home/data/models/hero_model.dart';
import 'power_stats_widget.dart';

class HeroInfoCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback? onTap;

  const HeroInfoCard({
    super.key,
    required this.hero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Header
              Row(
                children: [
                  // Hero Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: hero.thumbnail != null
                        ? Image.network(
                            hero.thumbnail!,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                  SizedBox(width: 12.w),
                  // Hero Basic Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hero.name ?? 'Unknown Hero',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hero.fullName != null && hero.fullName != hero.name)
                          Text(
                            hero.fullName!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            if (hero.publisher != null) ...[
                              _buildInfoChip(hero.publisher!, Colors.blue),
                              SizedBox(width: 8.w),
                            ],
                            if (hero.alignment != null)
                              _buildAlignmentChip(hero.alignment!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // Additional Info
              if (hero.race != null || hero.gender != null || hero.occupation != null)
                _buildAdditionalInfo(),
              
              SizedBox(height: 16.h),
              
              // Power Stats
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
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.person,
        size: 30.sp,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAlignmentChip(String alignment) {
    Color color;
    switch (alignment.toLowerCase()) {
      case 'good':
        color = Colors.green;
        break;
      case 'bad':
        color = Colors.red;
        break;
      case 'neutral':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return _buildInfoChip(alignment, color);
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero.race != null)
            _buildInfoRow('Race', hero.race!),
          if (hero.gender != null)
            _buildInfoRow('Gender', hero.gender!),
          if (hero.occupation != null)
            _buildInfoRow('Occupation', hero.occupation!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
