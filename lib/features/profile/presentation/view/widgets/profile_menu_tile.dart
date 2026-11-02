import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 4,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor ?? AppColors.blackBase),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppStyles.medium16Inter.copyWith(
                  color: textColor ?? AppColors.blackBase,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
