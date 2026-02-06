import 'package:dbt_society/core/navigation/app_navigator.dart';
import 'package:dbt_society/features/leads/presentation/pages/leads_page.dart';
import 'package:flutter/material.dart';

import 'core/storage/token_storage.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await TokenStorage.getToken();

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      navigatorKey: AppNavigator.navigatorKey,

      home: isLoggedIn ? const LeadsPage() : const LoginPage(),
    );
  }
}
