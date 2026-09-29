import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/cubit/driver_order_history_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_history_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_history_summary_card.dart';

class DriverOrderHistoryView extends StatelessWidget {
  const DriverOrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DriverOrderHistoryCubit>()
            ..doEvent(const GetDriverOrderHistoryEvent()),
      child: const _DriverOrderHistoryContent(),
    );
  }
}

class _DriverOrderHistoryContent extends StatelessWidget {
  const _DriverOrderHistoryContent();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.myOrders),
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.purpleBase,
          onRefresh: () async {
            context.read<DriverOrderHistoryCubit>().doEvent(
              const RefreshOrderHistoryEvent(),
            );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummarySection(),
                      const SizedBox(height: 20),
                      Text(
                        localizations.recentOrders,
                        style: AppStyles.regular14InterW500.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildOrdersListSliver(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return BlocBuilder<DriverOrderHistoryCubit, DriverOrderHistoryState>(
      buildWhen: (previous, current) =>
          previous.cancelledCount != current.cancelledCount ||
          previous.completedCount != current.completedCount,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: OrderHistorySummaryCard(
                count: state.cancelledCount,
                isCompleted: false,
                isCancelled: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OrderHistorySummaryCard(
                count: state.completedCount,
                isCompleted: true,
                isCancelled: false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersListSliver() {
    return BlocBuilder<DriverOrderHistoryCubit, DriverOrderHistoryState>(
      buildWhen: (previous, current) =>
          previous.historyState != current.historyState,
      builder: (context, state) {
        if (state.historyState.isLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.purpleBase),
            ),
          );
        }

        if (state.historyState.errorMessage != null) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildErrorState(context, state.historyState.errorMessage!),
          );
        }

        final orders = state.historyState.data ?? [];
        if (orders.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(context),
          );
        }

        return SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 12),
                child: OrderHistoryCard(
                  order: order,
                  onTap: () => _navigateToDetails(context, order),
                ),
              );
            }, childCount: orders.length),
          ),
        );
      },
    );
  }

  void _navigateToDetails(BuildContext context, OrderHistoryEntity order) {
    context.push('${AppRoutes.historicalOrderDetails}/${order.id}');
  }

  Widget _buildEmptyState(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: AppColors.grey,
            ),
            const SizedBox(height: 12),
            Text(localizations.noOrdersFound, style: AppStyles.regular14Inter),
          ],
        ),
      ),
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
                  context.read<DriverOrderHistoryCubit>().doEvent(
                    const GetDriverOrderHistoryEvent(),
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
