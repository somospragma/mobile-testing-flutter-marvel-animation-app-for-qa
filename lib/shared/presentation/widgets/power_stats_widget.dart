import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'stat_bar_widget.dart';

class PowerStatsWidget extends StatelessWidget {
  final String? intelligence;
  final String? strength;
  final String? speed;
  final String? durability;
  final String? power;
  final String? combat;

  const PowerStatsWidget({
    super.key,
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Power Stats',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          StatBarWidget(
            label: 'Intelligence',
            value: int.tryParse(intelligence ?? '0') ?? 0,
            color: Colors.blue,
          ),
          StatBarWidget(
            label: 'Strength',
            value: int.tryParse(strength ?? '0') ?? 0,
            color: Colors.red,
          ),
          StatBarWidget(
            label: 'Speed',
            value: int.tryParse(speed ?? '0') ?? 0,
            color: Colors.green,
          ),
          StatBarWidget(
            label: 'Durability',
            value: int.tryParse(durability ?? '0') ?? 0,
            color: Colors.orange,
          ),
          StatBarWidget(
            label: 'Power',
            value: int.tryParse(power ?? '0') ?? 0,
            color: Colors.purple,
          ),
          StatBarWidget(
            label: 'Combat',
            value: int.tryParse(combat ?? '0') ?? 0,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
