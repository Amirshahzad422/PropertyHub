import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.favorite_border,
            iconColor: Colors.brown,
            bgColor: Colors.brown.shade50,
            count: '24',
            label: 'Saved Properties',
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            icon: Icons.calendar_today_outlined,
            iconColor: Colors.grey.shade700,
            bgColor: Colors.grey.shade200,
            count: '3',
            label: 'Scheduled Visits',
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            icon: Icons.chat_bubble_outline,
            iconColor: Colors.orange.shade700,
            bgColor: Colors.orange.shade50,
            count: '5',
            label: 'Active Inquiries',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String count,
    required String label,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            count,
            style: TextStyle(
              fontFamily: AppTypography.serifFont,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoalText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
