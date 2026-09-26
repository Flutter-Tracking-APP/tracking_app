import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/driver_home_view.dart';
import 'package:tracking_app/features/profile/presentation/view/profile_view.dart';

class DriverMainShellView extends StatefulWidget {
  final int initialIndex;

  const DriverMainShellView({super.key, this.initialIndex = 0});

  @override
  State<DriverMainShellView> createState() => _DriverMainShellViewState();
}

class _DriverMainShellViewState extends State<DriverMainShellView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final tabs = [
      const DriverHomeView(),
      _buildOrdersPlaceholder(localizations),
      const ProfileView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.purpleBase,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: AppStyles.regular12Inter.copyWith(
          color: AppColors.purpleBase,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppStyles.regular12Inter,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: localizations.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: localizations.ordersTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: localizations.profileTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersPlaceholder(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.ordersTab,
            style: AppStyles.medium18Inter,
          ),
        ],
      ),
    );
  }
}
