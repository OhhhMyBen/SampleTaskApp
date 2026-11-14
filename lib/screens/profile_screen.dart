import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onLogout;

  const ProfileScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();
    final activeCount = taskService.pendingCount;

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Title and Pro Badge
                  _buildHeader(),

                  const SizedBox(height: 16),

                  // User Card (Alex Morgan)
                  _buildUserCard(activeCount),

                  const SizedBox(height: 16),

                  // Local Vault Usage Card
                  _buildStorageCard(),

                  const SizedBox(height: 20),

                  // Settings Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account & App Settings',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ClayColors.textPrimary,
                            ),
                      ),
                      const Text(
                        'General',
                        style: TextStyle(
                          fontSize: 12,
                          color: ClayColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.person_rounded,
                    iconBg: ClayColors.lavenderSurface,
                    iconColor: ClayColors.lavenderText,
                    title: 'Edit Profile',
                    subtitle: 'Personal details, birthday, display name',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.lock_reset_rounded,
                    iconBg: ClayColors.blueSurface,
                    iconColor: ClayColors.primary,
                    title: 'Change Password',
                    subtitle: 'Security & lock PIN configuration',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.cloud_off_rounded,
                    iconBg: ClayColors.mintSurface,
                    iconColor: ClayColors.mintText,
                    title: 'Offline Data & Backup',
                    subtitle: 'SQLite local database sync status',
                    badge: '100% On-Device',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.tune_rounded,
                    iconBg: ClayColors.surfaceContainer,
                    iconColor: ClayColors.textPrimary,
                    title: 'App Preferences',
                    subtitle: 'Haptic feedback, notifications & theme',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.info_rounded,
                    iconBg: ClayColors.lavenderSurface,
                    iconColor: ClayColors.lavenderText,
                    title: 'About Clay Tasks',
                    subtitle: 'Zero tracking, privacy pledge',
                    badge: 'v1.2.0',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // Log Out Button (Soft Peach / Destructive)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: ClayColors.surfaceElevated,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text(
                            'Log Out',
                            style: TextStyle(
                              color: ClayColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to log out of your local workspace?',
                            style: TextStyle(color: ClayColors.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ClayColors.peachSurface,
                                foregroundColor: ClayColors.peachText,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                onLogout?.call();
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: ClayColors.peachSurface,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE2CFD2).withValues(alpha: 0.9),
                            offset: const Offset(4, 4),
                            blurRadius: 12,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4, -4),
                            blurRadius: 12,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.logout_rounded,
                            color: ClayColors.peachText,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Log Out of Workspace',
                            style: TextStyle(
                              color: ClayColors.peachText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Clay Tasks • Tactile Privacy Engine • Build 240',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: ClayColors.outline,
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: ClayColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ClayShadows.subtle(offset: 4, blur: 8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.layers_rounded,
                  color: ClayColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clay Tasks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ClayColors.textPrimary,
                        ),
                  ),
                  Text(
                    'Personal Workspace',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ClayColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
          ClayIconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: ClayColors.textSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: ClayColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Your personal workspace & preferences.',
              style: TextStyle(
                fontSize: 13,
                color: ClayColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: ClayColors.mintSurface,
            borderRadius: BorderRadius.circular(999),
            boxShadow: ClayShadows.subtle(offset: 2, blur: 5),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Row(
            children: const [
              Icon(
                Icons.verified_user_rounded,
                size: 14,
                color: ClayColors.mintText,
              ),
              SizedBox(width: 4),
              Text(
                'Pro Plan',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ClayColors.mintText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(int activeCount) {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.surfaceElevated,
        borderRadius: BorderRadius.circular(26),
        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ClayColors.surfaceContainer,
                  boxShadow: ClayShadows.extruded(offset: 5, blur: 12),
                  border: Border.all(color: Colors.white, width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8C9EFF), Color(0xFFDCE3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ClayColors.primary,
                    boxShadow: ClayShadows.subtle(offset: 2, blur: 5),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Alex Morgan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ClayColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'alex@claytasks.app',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ClayColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildStatPill(
                Icons.radio_button_checked_rounded,
                '$activeCount Active Tasks',
                ClayColors.blueSurface,
                ClayColors.primary,
              ),
              _buildStatPill(
                Icons.task_alt_rounded,
                '32 Total Done',
                ClayColors.mintSurface,
                ClayColors.mintText,
              ),
              _buildStatPill(
                Icons.lock_rounded,
                'Local Storage Only',
                ClayColors.surfaceContainerLow,
                ClayColors.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
      IconData icon, String text, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: ClayShadows.subtle(offset: 2, blur: 5),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard() {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ClayShadows.extruded(offset: 6, blur: 14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClayColors.surfaceContainer,
                      boxShadow: ClayShadows.recessed,
                    ),
                    child: const Icon(
                      Icons.storage_rounded,
                      color: ClayColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Local Vault Usage',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ClayColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                '14.8 MB / 500 MB',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ClayColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Recessed Progress Bar
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: ClayColors.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
              boxShadow: ClayShadows.recessed,
            ),
            padding: const EdgeInsets.all(1.5),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.12,
              child: Container(
                decoration: BoxDecoration(
                  color: ClayColors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: ClayShadows.subtle(offset: 1, blur: 3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '• SQLite DB v3',
                style: TextStyle(
                  fontSize: 11,
                  color: ClayColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '0 cloud queries logged',
                style: TextStyle(
                  fontSize: 11,
                  color: ClayColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ClayColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ClayShadows.extruded(offset: 5, blur: 12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: ClayShadows.subtle(offset: 2, blur: 5),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ClayColors.textPrimary,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ClayColors.mintSurface,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: ClayColors.mintText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ClayColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ClayColors.surfaceElevated,
                boxShadow: ClayShadows.subtle(offset: 1.5, blur: 3),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: ClayColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
