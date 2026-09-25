import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class FileUploadField extends FormField<File> {
  final String label;
  final String hint;
  final File? file;
  final VoidCallback onTap;
  final String? errorText;

  FileUploadField({
    super.key,
    required this.label,
    required this.hint,
    this.file,
    required this.onTap,
    this.errorText,
    super.validator,
    super.autovalidateMode,
  }) : super(
         initialValue: file,
         builder: (FormFieldState<File> field) {
           final state = field as _FileUploadFieldState;
           final currentFile = state.value ?? state.widget.file;
           final fileName = currentFile?.path
               .split(Platform.pathSeparator)
               .last;
           final displayError = currentFile != null
               ? null
               : (state.errorText ?? errorText);

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
                 errorText: displayError,
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
         },
       );

  @override
  FormFieldState<File> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends FormFieldState<File> {
  @override
  FileUploadField get widget => super.widget as FileUploadField;

  @override
  void didUpdateWidget(FileUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != oldWidget.file) {
      setValue(widget.file);
    }
  }
}
