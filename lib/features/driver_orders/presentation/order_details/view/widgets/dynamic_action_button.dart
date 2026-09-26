import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_state.dart';

typedef OrderDetailsBottomActionButton = DynamicActionButton;

class DynamicActionButton extends StatelessWidget {
  final String orderId;

  const DynamicActionButton({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (previous, current) =>
          previous.orderDetailsState != current.orderDetailsState ||
          previous.isUpdatingStatus != current.isUpdatingStatus ||
          previous.updateStatusState != current.updateStatusState,
      builder: (context, state) {
        final order = state.orderDetailsState.data;
        if (order == null) return const SizedBox.shrink();

        final localizations = AppLocalizations.of(context)!;
        final label = _getActionLabel(localizations, order.status);
        if (label == null) return const SizedBox.shrink();

        final isUpdating = state.isUpdatingStatus || state.updateStatusState.isLoading;

        return Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton(
              text: label,
              isLoading: isUpdating,
              onPressed: isUpdating
                  ? null
                  : () {
                      context.read<OrderDetailsCubit>().doEvent(
                            UpdateNextStatusEvent(orderId),
                          );
                    },
            ),
          ),
        );
      },
    );
  }

  String? _getActionLabel(
    AppLocalizations localizations,
    OrderFulfillmentStatus status,
  ) {
    return switch (status) {
      OrderFulfillmentStatus.accepted ||
      OrderFulfillmentStatus.arrivedAtPickup =>
        localizations.arrivedAtPickupPoint,
      OrderFulfillmentStatus.picked => localizations.startDeliver,
      OrderFulfillmentStatus.outForDelivery => localizations.arrivedToUser,
      OrderFulfillmentStatus.arrived => localizations.handOrderToUser,
      OrderFulfillmentStatus.delivered => null,
    };
  }
}
