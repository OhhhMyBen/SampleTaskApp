import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/clay_theme.dart';
import 'tasks_hub_screen.dart';
import 'calendar_screen.dart';
import 'completed_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final VoidCallback onLogout;

  const MainShell({super.key, required this.onLogout});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TasksHubScreen(onOpenProfile: () => _switchTab(3)),
      const CalendarScreen(),
      const CompletedScreen(),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: Stack(
        children: [
          // Screen View
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),

          // Floating Tactile Bottom Navigation Dock
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: _buildBottomNavDock(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavDock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: ClayColors.surfaceContainerLow.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(26),
            boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.assignment_rounded, 'Tasks'),
              _buildNavItem(1, Icons.calendar_today_rounded, 'Calendar'),
              _buildNavItem(2, Icons.check_circle_rounded, 'Completed'),
              _buildNavItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _switchTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 54,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 8,
          vertical: 4,
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: ClayColors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: ClayColors.shadowPrimaryDark.withValues(alpha: 0.9),
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 8,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: 1.0,
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : ClayColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : ClayColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
