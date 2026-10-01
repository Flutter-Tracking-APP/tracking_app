import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/extensions/app_failure_extension.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/historical_order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/cubit/historical_order_details_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/historical_order_details/view/widgets/historical_order_status_header.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_items_list_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_summary_section.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/store_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/user_address_card.dart';

class HistoricalOrderDetailsView extends StatelessWidget {
  final String orderId;

  const HistoricalOrderDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<HistoricalOrderDetailsCubit>()
            ..doEvent(GetHistoricalOrderDetailsEvent(orderId)),
      child: _HistoricalOrderDetailsContent(orderId: orderId),
    );
  }
}

class _HistoricalOrderDetailsContent extends StatelessWidget {
  final String orderId;

  const _HistoricalOrderDetailsContent({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.orderDetails),
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: SafeArea(
        child:
            BlocBuilder<
              HistoricalOrderDetailsCubit,
              HistoricalOrderDetailsState
            >(
              builder: (context, state) {
                if (state.detailsState.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.purpleBase,
                    ),
                  );
                }

                if (state.detailsState.failure != null ||
                    state.detailsState.errorMessage != null) {
                  final message = state.detailsState.failure
                          ?.toLocalizedMessage(context) ??
                      state.detailsState.errorMessage!;
                  return _buildErrorState(
                    context,
                    message,
                  );
                }

                final details = state.detailsState.data;
                if (details == null) {
                  return const SizedBox.shrink();
                }

                return _buildDetailsList(context, details);
              },
            ),
      ),
    );
  }

  Widget _buildDetailsList(
    BuildContext context,
    HistoricalOrderDetailsEntity details,
  ) {
    return ListView(
      children: [
        HistoricalOrderStatusHeader(
          isCompleted: details.isCompleted,
          isCancelled: details.isCancelled,
          orderNumber: details.orderNumber,
        ),
        StoreAddressCard(store: details.store, showActions: false),
        UserAddressCard(user: details.user, showActions: false),
        if (details.items.isNotEmpty) OrderItemsListView(items: details.items),
        OrderSummarySection(order: details.toOrderDetailsEntity()),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
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
                text: localizations.retry,
                onPressed: () {
                  context.read<HistoricalOrderDetailsCubit>().doEvent(
                    GetHistoricalOrderDetailsEvent(orderId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
