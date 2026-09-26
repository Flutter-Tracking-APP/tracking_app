import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_state.dart';

class AvailableOrderCard extends StatelessWidget {
  final OrderEntity order;
  final ValueChanged<String> onAccept;

  const AvailableOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final storeName = order.storeName.isNotEmpty
        ? order.storeName
        : localizations.floweryStore;
    final customerName = order.customerName.isNotEmpty
        ? order.customerName
        : order.user.name;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.white[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white[500]!.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.title.isNotEmpty ? order.title : localizations.flowerOrder,
            style: AppStyles.regular14InterW500,
          ),
          const SizedBox(height: 12),
          Text(
            localizations.pickupAddress,
            style: AppStyles.regular12Inter,
          ),
          const SizedBox(height: 6),
          _buildAddressTile(
            title: storeName,
            address: order.storeAddress,
            isStore: true,
          ),
          const SizedBox(height: 12),
          Text(
            localizations.userAddress,
            style: AppStyles.regular12Inter,
          ),
          const SizedBox(height: 6),
          _buildAddressTile(
            title: customerName,
            address: order.customerAddress,
            isStore: false,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${localizations.egp} ${order.totalAmount}',
                style: AppStyles.bold20Inter,
              ),
              BlocBuilder<DriverHomeCubit, DriverHomeState>(
                buildWhen: (previous, current) =>
                    (previous.claimingOrderId == order.id) !=
                    (current.claimingOrderId == order.id),
                builder: (context, state) {
                  final isAccepting = state.claimingOrderId == order.id;
                  return SizedBox(
                    height: 40,
                    width: 120,
                    child: AppButton(
                      text: localizations.accept,
                      isLoading: isAccepting,
                      padding: EdgeInsets.zero,
                      textStyle: AppStyles.regular14InterW500,
                      onPressed: isAccepting ? null : () => onAccept(order.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile({
    required String title,
    required String address,
    required bool isStore,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white[500]!.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isStore ? AppColors.purpleBase : AppColors.pink10,
            child: Icon(
              isStore ? Icons.local_florist : Icons.person,
              color: isStore ? AppColors.whiteBase : AppColors.purpleBase,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.regular13W500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: AppStyles.regular12Inter,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
