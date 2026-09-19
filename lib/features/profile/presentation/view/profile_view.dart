import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/logout_dialog.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/profile_header_card.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/profile_menu_tile.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/vehicle_info_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..doEvent(const GetProfileEvent()),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            prev.logoutState != curr.logoutState ||
            prev.profileState.errorMessage != curr.profileState.errorMessage,
        listener: _handleListener,
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final languageName = isArabic
              ? l10n.languageArabic
              : l10n.languageEnglish;

          return Scaffold(
            backgroundColor: AppColors.whiteBase,
            appBar: _buildAppBar(context, l10n),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    ProfileHeaderCard(
                      profile: state.profileState.data,
                      onEditTap: () => _navigateToEditProfile(context, state),
                    ),
                    const SizedBox(height: 24),
                    VehicleInfoTile(
                      onTap: () => context.push(AppRoutes.editVehicleInfo),
                    ),
                    const SizedBox(height: 16),
                    ProfileMenuTile(
                      icon: Icons.language_outlined,
                      title: l10n.languageLabel,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            languageName,
                            style: AppStyles.regular14Inter.copyWith(
                              color: AppColors.purpleBase,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                      onTap: () => LanguageBottomSheet.show(context),
                    ),
                    const Divider(height: 1, color: AppColors.whiteBase),
                    ProfileMenuTile(
                      icon: Icons.logout_outlined,
                      title: l10n.logoutLabel,
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      trailing: const SizedBox.shrink(),
                      onTap: () => _onLogoutTap(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Text('Flowery', style: AppStyles.appTitle),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  void _navigateToEditProfile(BuildContext context, ProfileState state) {
    context.push(AppRoutes.editProfile, extra: state.profileState.data);
  }

  void _onLogoutTap(BuildContext context) {
    LogoutDialog.show(
      context,
      onConfirm: () {
        context.read<ProfileCubit>().doEvent(const LogoutEvent());
      },
    );
  }

  void _handleListener(BuildContext context, ProfileState state) {
    if (state.logoutState.data == true) {
      context.go(AppRoutes.login);
    }
    if (state.profileState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.profileState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
