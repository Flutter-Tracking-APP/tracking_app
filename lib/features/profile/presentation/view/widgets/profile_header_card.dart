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
        : '';
    final email = profile?.email.isNotEmpty == true ? profile!.email : '';
    final phone = profile?.phoneNumber.isNotEmpty == true
        ? profile!.phoneNumber
        : '';

    return InkWell(
      onTap: onEditTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white[500]!, width: 1),
        ),
        child: Row(
          children: [
            _buildAvatar(avatarUrl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fullName,
                    style: AppStyles.bold20Inter.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppStyles.regular12Inter,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: AppStyles.regular12Inter,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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

  Widget _buildAvatar(String? avatarUrl) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purpleBase.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.purpleBase.withValues(alpha: 0.2),
          width: 1.5,
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
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(AppImages.flower, fit: BoxFit.contain),
    );
  }
}
