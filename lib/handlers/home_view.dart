import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/session/session_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("data"),
            ElevatedButton(
              onPressed: () async {
              await getIt<SessionService>().clearSession();
         

                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
              child: Text("data"),
            ),
          ],
        ),
      ),
    );
  }
}
