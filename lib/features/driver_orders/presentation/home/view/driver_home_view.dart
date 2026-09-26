import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_view_mixin.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_cubit.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/cubit/driver_home_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/widgets/available_orders_list_view.dart';
import 'package:tracking_app/features/driver_orders/presentation/home/view/widgets/driver_home_header.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/order_details_view.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DriverHomeCubit>(),
      child: const _DriverHomeContent(),
    );
  }
}

class _DriverHomeContent extends StatefulWidget {
  const _DriverHomeContent();

  @override
  State<_DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<_DriverHomeContent>
    with BaseViewMixin<_DriverHomeContent, DriverHomeCubit, BaseEvent> {
  @override
  DriverHomeCubit get cubit => context.read<DriverHomeCubit>();

  @override
  void initState() {
    super.initState();
    cubit.doEvent(const InitHomeEvent());
  }

  @override
  void onCustomEvent(BaseEvent event) {
    switch (event) {
      case OrderClaimedSuccessUiEvent():
        showSuccessSnackBar(
          AppLocalizations.of(context)!.orderClaimedSuccessfully,
        );
        cubit.doEvent(const InitHomeEvent());
      case NavigateToActiveOrderEvent():
        break;
      case _:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      buildWhen: (previous, current) =>
          previous.activeOrder != current.activeOrder ||
          previous.checkingActiveOrder != current.checkingActiveOrder ||
          previous.ordersState != current.ordersState,
      builder: (context, state) {
        if (state.activeOrder != null) {
          return OrderDetailsView(
            orderId: state.activeOrder!.id,
            showBackButton: false,
            onOrderCompleted: () {
              cubit.doEvent(const InitHomeEvent());
            },
          );
        }

        if (state.checkingActiveOrder ||
            (state.activeOrder == null && state.ordersState.isLoading)) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.purpleBase),
          );
        }

        return const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DriverHomeHeader(),
              Expanded(child: AvailableOrdersListView()),
            ],
          ),
        );
      },
    );
  }
}
