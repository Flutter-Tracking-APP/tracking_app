import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_images.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserProfileEntity? profile;
  final VoidCallback onEditTap;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile?.profilePictureUrl;
    final fullName = profile?.fullName.isNotEmpty == true
        ? profile!.fullName
        : 'Driver';
    final email = profile?.email ?? '';

    return Column(
      children: [
        _buildAvatar(avatarUrl),
        const SizedBox(height: 12),
        InkWell(
          onTap: onEditTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(fullName, style: AppStyles.bold20Inter),
                const SizedBox(width: 6),
                const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(email, style: AppStyles.regular14InterGreyHeight15),
        ],
      ],
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purpleBase.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.purpleBase.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null && avatarUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => _buildFallbackFlower(),
                errorWidget: (_, _, _) => _buildFallbackFlower(),
              )
            : _buildFallbackFlower(),
      ),
    );
  }

  Widget _buildFallbackFlower() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SvgPicture.asset(AppImages.flower, fit: BoxFit.contain),
    );
  }
}
