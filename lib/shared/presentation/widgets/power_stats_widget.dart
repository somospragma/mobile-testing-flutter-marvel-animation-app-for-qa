import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          _buildStatBar('Intelligence', intelligence, Colors.blue),
          _buildStatBar('Strength', strength, Colors.red),
          _buildStatBar('Speed', speed, Colors.green),
          _buildStatBar('Durability', durability, Colors.orange),
          _buildStatBar('Power', power, Colors.purple),
          _buildStatBar('Combat', combat, Colors.teal),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, String? value, Color color) {
    final int statValue = int.tryParse(value ?? '0') ?? 0;
    final double percentage = statValue / 100.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            statValue.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
