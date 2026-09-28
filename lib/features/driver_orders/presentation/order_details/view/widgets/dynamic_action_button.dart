import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_state.dart';

typedef OrderDetailsBottomActionButton = DynamicActionButton;

class DynamicActionButton extends StatefulWidget {
  final String orderId;

  const DynamicActionButton({super.key, required this.orderId});

  @override
  State<DynamicActionButton> createState() => _DynamicActionButtonState();
}

class _DynamicActionButtonState extends State<DynamicActionButton> {
  bool _showSuccessCheckmark = false;
  StreamSubscription<BaseEvent>? _subscription;
  Timer? _checkmarkTimer;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OrderDetailsCubit>();
    _subscription = cubit.eventStream.listen((event) {
      if (event is OrderStatusUpdatedUiEvent && mounted) {
        setState(() => _showSuccessCheckmark = true);
        _checkmarkTimer?.cancel();
        _checkmarkTimer = Timer(const Duration(milliseconds: 1200), () {
          if (mounted) {
            setState(() => _showSuccessCheckmark = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _checkmarkTimer?.cancel();
    super.dispose();
  }

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
        final isUpdating =
            state.isUpdatingStatus || state.updateStatusState.isLoading;
        final isDisabled = isUpdating || _isWaitingStatus(order.status);

        return Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              layoutBuilder: (currentChild, previousChildren) {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...previousChildren,
                      ?currentChild,
                    ],
                  ),
                );
              },
              child: _showSuccessCheckmark
                  ? _buildSuccessButton()
                  : _buildActionButton(
                      label: label,
                      isUpdating: isUpdating,
                      isDisabled: isDisabled,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        key: const ValueKey('success_checkmark_button'),
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          disabledBackgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Icon(
          Icons.check,
          color: AppColors.whiteBase,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isUpdating,
    required bool isDisabled,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: AppButton(
        key: ValueKey(label),
        text: label,
        isLoading: isUpdating,
        disabledBackgroundColor: AppColors.white[500],
        disabledTextColor: AppColors.whiteBase,
        onPressed: isDisabled
            ? null
            : () {
                context.read<OrderDetailsCubit>().doEvent(
                      UpdateNextStatusEvent(widget.orderId),
                    );
              },
      ),
    );
  }

  bool _isWaitingStatus(OrderFulfillmentStatus status) {
    return status == OrderFulfillmentStatus.arrivedAtPickup ||
        status == OrderFulfillmentStatus.awaitingConfirmation ||
        status == OrderFulfillmentStatus.delivered;
  }

  String _getActionLabel(
    AppLocalizations localizations,
    OrderFulfillmentStatus status,
  ) {
    return switch (status) {
      OrderFulfillmentStatus.accepted => localizations.arrivedAtPickupPoint,
      OrderFulfillmentStatus.arrivedAtPickup =>
        localizations.waitingForStoreApproval,
      OrderFulfillmentStatus.picked => localizations.startDeliver,
      OrderFulfillmentStatus.outForDelivery => localizations.arrivedToUser,
      OrderFulfillmentStatus.arrived => localizations.handOrderToUser,
      OrderFulfillmentStatus.awaitingConfirmation ||
      OrderFulfillmentStatus.delivered =>
        localizations.waitingForConfirmation,
    };
  }
}
