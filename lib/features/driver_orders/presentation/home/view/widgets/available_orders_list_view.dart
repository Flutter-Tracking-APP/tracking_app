import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/widgets/available_order_card.dart';

class AvailableOrdersListView extends StatelessWidget {
  const AvailableOrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      buildWhen: (previous, current) =>
          previous.ordersState != current.ordersState ||
          previous.checkingActiveOrder != current.checkingActiveOrder ||
          previous.activeOrder != current.activeOrder,
      builder: (context, state) {
        if (state.checkingActiveOrder ||
            state.activeOrder != null ||
            state.ordersState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.purpleBase),
          );
        }

        if (state.ordersState.errorMessage != null) {
          return _buildErrorState(context, state.ordersState.errorMessage!);
        }

        final orders = state.ordersState.data ?? [];
        if (orders.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: AppColors.purpleBase,
          onRefresh: () async {
            context.read<DriverHomeCubit>().doEvent(
                  const GetAvailableOrdersEvent(),
                );
          },
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return AvailableOrderCard(
                order: order,
                onAccept: (orderId) {
                  context.read<DriverHomeCubit>().doEvent(
                        ClaimOrderEvent(orderId),
                      );
                },
              );
            },
          ),
        );
      },
    );
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
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noAvailableOrders,
              style: AppStyles.medium16Roboto,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 140,
              height: 40,
              child: AppButton(
                text: localizations.updateButton,
                onPressed: () {
                  context.read<DriverHomeCubit>().doEvent(
                        const GetAvailableOrdersEvent(),
                      );
                },
              ),
            ),
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
            const Icon(
              Icons.error_outline,
              size: 56,
              color: AppColors.error,
            ),
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
                  context.read<DriverHomeCubit>().doEvent(
                        const GetAvailableOrdersEvent(),
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
