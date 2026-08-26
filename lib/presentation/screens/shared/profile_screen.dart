import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/presentation/widgets/profile/profile_header.dart';
import 'package:propertyhub/presentation/widgets/profile/profile_menu_section.dart';
import 'package:propertyhub/presentation/widgets/profile/profile_stats_row.dart';
import 'package:propertyhub/presentation/widgets/profile/profile_logout_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfileHeader(),
              const SizedBox(height: 32),
              const ProfileStatsRow(),
              const SizedBox(height: 32),
              ProfileMenuSection(
                title: 'PROFILE & PREFERENCES',
                items: [
                  ProfileMenuItemData(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    icon: Icons.tune,
                    title: 'Buying Preferences',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ProfileMenuSection(
                title: 'MY ACTIVITY',
                items: [
                  ProfileMenuItemData(
                    icon: Icons.calculate_outlined,
                    title: 'Mortgage Calculations',
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    icon: Icons.description_outlined,
                    title: 'Rental Applications',
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    icon: Icons.history,
                    title: 'Visit History',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ProfileMenuSection(
                title: 'ACCOUNT & SUPPORT',
                items: [
                  ProfileMenuItemData(
                    icon: Icons.settings_outlined,
                    title: 'Account Settings',
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const ProfileLogoutButton(),
              const SizedBox(height: 48), // Padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
