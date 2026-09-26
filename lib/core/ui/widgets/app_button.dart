import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.textColor,
    this.disabledTextColor,
    this.isLoading = false,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.purpleBase,
        foregroundColor: textColor ?? AppColors.whiteBase,
        disabledBackgroundColor:
            disabledBackgroundColor ?? AppColors.white[500],
        disabledForegroundColor:
            disabledTextColor ?? AppColors.whiteBase,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        padding: padding,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              text,
              style: (textStyle ?? AppStyles.medium16Inter).copyWith(
                color: onPressed != null
                    ? (textColor ?? AppColors.whiteBase)
                    : (disabledTextColor ?? AppColors.whiteBase),
              ),
            ),
    );
  }
}
