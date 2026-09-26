import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_state.dart';

class DynamicActionButton extends StatelessWidget {
  final String orderId;

  const DynamicActionButton({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (previous, current) =>
          previous.orderDetailsState != current.orderDetailsState ||
          previous.updateStatusState != current.updateStatusState,
      builder: (context, state) {
        final order = state.orderDetailsState.data;
        if (order == null) return const SizedBox.shrink();

        final localizations = AppLocalizations.of(context)!;
        final (label, nextStatus) = _getActionConfig(
          localizations,
          order.status,
        );

        final isUpdating = state.updateStatusState.isLoading;

        return Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton(
              text: label,
              isLoading: isUpdating,
              onPressed: nextStatus == null || isUpdating
                  ? null
                  : () {
                      context.read<OrderDetailsCubit>().doEvent(
                            UpdateOrderStatusEvent(
                              orderId: orderId,
                              targetStatus: nextStatus,
                            ),
                          );
                    },
            ),
          ),
        );
      },
    );
  }

  (String, OrderFulfillmentStatus?) _getActionConfig(
    AppLocalizations localizations,
    OrderFulfillmentStatus status,
  ) {
    return switch (status) {
      OrderFulfillmentStatus.accepted => (
          localizations.arrivedAtPickupPoint,
          OrderFulfillmentStatus.arrivedAtPickup,
        ),
      OrderFulfillmentStatus.arrivedAtPickup => (
          localizations.orderPickedButton,
          OrderFulfillmentStatus.picked,
        ),
      OrderFulfillmentStatus.picked => (
          localizations.startDeliver,
          OrderFulfillmentStatus.outForDelivery,
        ),
      OrderFulfillmentStatus.outForDelivery => (
          localizations.arrivedToUser,
          OrderFulfillmentStatus.delivered,
        ),
      OrderFulfillmentStatus.delivered => (
          localizations.statusDelivered,
          null,
        ),
    };
  }
}
