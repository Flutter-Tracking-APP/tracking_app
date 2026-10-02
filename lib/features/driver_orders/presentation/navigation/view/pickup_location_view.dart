import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_constants.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_view_model.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_state.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/view/widgets/navigation_map_markers.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/store_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/user_address_card.dart';

class PickupLocationView extends StatelessWidget {
  final String orderId;
  final OrderDetailsEntity? order;

  const PickupLocationView({super.key, required this.orderId, this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DriverNavigationViewModel>()
        ..doEvent(
          InitNavigationEvent(
            orderId: orderId,
            isPickup: true,
            initialOrder: order,
          ),
        ),
      child: const _PickupLocationContent(),
    );
  }
}

class _PickupLocationContent extends StatelessWidget {
  const _PickupLocationContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriverNavigationViewModel, DriverNavigationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purpleBase),
            );
          }

          if (state.errorMessage != null && state.order == null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final order = state.order;

          return Stack(
            children: [
              _buildMapView(context: context, state: state, order: order),
              _buildFloatingBackButton(context: context),
              _buildLocationCardsSection(order: order),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapView({
    required BuildContext context,
    required DriverNavigationState state,
    required OrderDetailsEntity? order,
  }) {
    return Positioned.fill(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: state.driverLocation,
          initialZoom: 14.5,
        ),
        children: [
          TileLayer(
            urlTemplate: AppConstants.mapTilerUrlTemplate,
            additionalOptions: {
              AppConstants.mapTilerApiKeyQueryParam: context
                  .read<DriverNavigationViewModel>()
                  .mapTilerApiKey,
            },
            userAgentPackageName: AppConstants.appPackageName,
            fallbackUrl: AppConstants.mapFallbackUrl,
          ),
          if (state.routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: state.routePoints,
                  color: AppColors.purpleBase,
                  strokeWidth: 4.5,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              Marker(
                point: state.destinationLocation,
                width: 150,
                height: 65,
                alignment: Alignment.topCenter,
                child: StoreMarkerWidget(
                  storeName:
                      (order?.store.name != null &&
                          order!.store.name.isNotEmpty)
                      ? order.store.name
                      : 'Flower',
                ),
              ),
              Marker(
                point: state.driverLocation,
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: const DriverLocationMarkerWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBackButton({required BuildContext context}) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: InkWell(
        onTap: () => context.pop(),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.purpleBase,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.whiteBase,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCardsSection({required OrderDetailsEntity? order}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Handle bar
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.purpleBase,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),

              if (order != null) ...[
                StoreAddressCard(
                  store: order.store,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                ),
                UserAddressCard(
                  user: order.user,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
