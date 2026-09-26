import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_view_mixin.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/cubit/order_details_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/dynamic_action_button.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_items_list_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_status_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_status_progress_bar.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_summary_section.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/store_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/user_address_card.dart';

class OrderDetailsView extends StatelessWidget {
  final String orderId;
  final bool showBackButton;
  final VoidCallback? onOrderCompleted;

  const OrderDetailsView({
    super.key,
    required this.orderId,
    this.showBackButton = true,
    this.onOrderCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderDetailsCubit>(),
      child: _OrderDetailsContent(
        orderId: orderId,
        showBackButton: showBackButton,
        onOrderCompleted: onOrderCompleted,
      ),
    );
  }
}

class _OrderDetailsContent extends StatefulWidget {
  final String orderId;
  final bool showBackButton;
  final VoidCallback? onOrderCompleted;

  const _OrderDetailsContent({
    required this.orderId,
    required this.showBackButton,
    this.onOrderCompleted,
  });

  @override
  State<_OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<_OrderDetailsContent>
    with BaseViewMixin<_OrderDetailsContent, OrderDetailsCubit, BaseEvent> {
  @override
  OrderDetailsCubit get cubit => context.read<OrderDetailsCubit>();

  @override
  void initState() {
    super.initState();
    cubit.doEvent(GetOrderDetailsEvent(widget.orderId));
  }

  @override
  void onCustomEvent(BaseEvent event) {
    final localizations = AppLocalizations.of(context)!;
    switch (event) {
      case OrderStatusUpdatedUiEvent():
        showSuccessSnackBar(localizations.orderStatusUpdatedSuccessfully);
      case OrderDeliveredUiEvent():
        showSuccessSnackBar(localizations.statusDelivered);
        widget.onOrderCompleted?.call();
      case _:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.orderDetails),
        automaticallyImplyLeading: false,
        leading: widget.showBackButton && Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(child: _buildDetailsBody()),
            DynamicActionButton(orderId: widget.orderId),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (previous, current) =>
          previous.orderDetailsState.data?.status !=
          current.orderDetailsState.data?.status,
      builder: (context, state) {
        final status =
            state.orderDetailsState.data?.status ?? OrderFulfillmentStatus.accepted;
        return OrderStatusProgressBar(status: status);
      },
    );
  }

  Widget _buildDetailsBody() {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (previous, current) =>
          previous.orderDetailsState != current.orderDetailsState,
      builder: (context, state) {
        if (state.orderDetailsState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.purpleBase),
          );
        }

        if (state.orderDetailsState.errorMessage != null) {
          return _buildErrorState(state.orderDetailsState.errorMessage!);
        }

        final order = state.orderDetailsState.data;
        if (order == null) {
          return const SizedBox.shrink();
        }

        return ListView(
          children: [
            OrderStatusCard(order: order),
            StoreAddressCard(store: order.store),
            UserAddressCard(user: order.user),
            if (order.items.isNotEmpty) OrderItemsListView(items: order.items),
            OrderSummarySection(order: order),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              error,
              style: AppStyles.regular14Inter,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 140,
              height: 40,
              child: AppButton(
                text: localizations.updateButton,
                onPressed: () {
                  cubit.doEvent(GetOrderDetailsEvent(widget.orderId));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
