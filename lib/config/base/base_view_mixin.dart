import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/core/const/app_colors.dart';

mixin BaseViewMixin<T extends StatefulWidget,
    C extends BaseCubit<dynamic, BaseEvent>> on State<T> {
  StreamSubscription<BaseEvent>? _eventSubscription;

  C get cubit;

  @override
  void initState() {
    super.initState();
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventSubscription = cubit.eventStream.listen((event) {
      if (!mounted) return;
      handleEvent(event);
    });
  }

  void handleEvent(BaseEvent event) {
    switch (event) {
      case DisplayError(:final errorMsg):
        showErrorSnackBar(errorMsg);
      case DisplaySuccess(:final successMsg):
        showSuccessSnackBar(successMsg);
      case NavigateEvent(:final routeName, :final extra):
        context.push(routeName, extra: extra);
      case CustomUiEvent():
        onCustomEvent(event);
    }
  }

  void onCustomEvent(BaseEvent event) {}

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }
}
