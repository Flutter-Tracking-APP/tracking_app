import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_images.dart';

class EditProfileAvatar extends StatelessWidget {
  final File? localImage;
  final String? networkUrl;
  final VoidCallback onPickImage;

  const EditProfileAvatar({
    super.key,
    this.localImage,
    this.networkUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purpleBase.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.purpleBase.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(child: _buildAvatarImage()),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: InkWell(
              onTap: onPickImage,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purpleBase,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (localImage != null) {
      return Image.file(localImage!, fit: BoxFit.cover);
    }
    if (networkUrl != null && networkUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: networkUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => _buildFlowerFallback(),
        errorWidget: (_, _, _) => _buildFlowerFallback(),
      );
    }
    return _buildFlowerFallback();
  }

  Widget _buildFlowerFallback() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: SvgPicture.asset(AppImages.flower, fit: BoxFit.contain),
    );
  }
}
