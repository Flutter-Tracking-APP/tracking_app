import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class FileUploadField extends StatelessWidget {
  final String label;
  final String hint;
  final File? file;
  final VoidCallback onTap;
  final String? errorText;

  const FileUploadField({
    super.key,
    required this.label,
    required this.hint,
    required this.file,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = file?.path.split(Platform.pathSeparator).last;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppStyles.regular12Roboto,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black, width: 1),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          errorText: errorText,
          errorMaxLines: 2,
          suffixIcon: const Icon(
            Icons.upload_outlined,
            color: AppColors.blackBase,
          ),
        ),
        child: Text(
          fileName ?? hint,
          style: fileName != null
              ? AppStyles.regular14InterW500
              : AppStyles.regular14Roboto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
