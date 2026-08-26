import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItemData> items;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: _buildMenuItems(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    final List<Widget> children = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      children.add(
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          leading: Icon(
            item.icon,
            color: AppColors.grayText,
            size: 22,
          ),
          title: Text(
            item.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.charcoalText,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onTap: item.onTap,
        ),
      );
      if (i < items.length - 1) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 52,
            endIndent: 16,
          ),
        );
      }
    }
    return children;
  }
}

class ProfileMenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
