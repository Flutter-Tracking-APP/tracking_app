import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/localization/locale_cubit.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: getIt<LocaleCubit>(),
        child: const LanguageBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleCubit>().state;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 18),
          Text(
            l10n.changeLanguageTitle,
            style: AppStyles.bold20Inter.copyWith(color: AppColors.purpleBase),
          ),
          const SizedBox(height: 18),
          _buildLanguageOption(
            context: context,
            title: l10n.languageArabic,
            isSelected: currentLocale.languageCode == 'ar',
            locale: const Locale('ar'),
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            context: context,
            title: l10n.languageEnglish,
            isSelected: currentLocale.languageCode == 'en',
            locale: const Locale('en'),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required Locale locale,
  }) {
    return InkWell(
      onTap: () {
        context.read<LocaleCubit>().changeLocale(locale);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purpleBase : AppColors.white[500]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.medium16Inter.copyWith(
                color: AppColors.blackBase,
              ),
            ),
            _buildRadioIndicator(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.purpleBase : AppColors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purpleBase,
                ),
              ),
            )
          : null,
    );
  }
}
