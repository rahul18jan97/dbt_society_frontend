import 'package:dbt_society/core/network/dio_client.dart';
import 'package:dbt_society/features/leads/presentation/pages/leads_page.dart';
import 'package:dbt_society/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final dio = DioClient.dio;

  bool loading = false;

  void login() async {
    setState(() => loading = true);
    try {
      final res = await dio.post(
        '/auth/login',
        data: {'email': emailCtrl.text, 'password': passCtrl.text},
      );

      await TokenStorage.saveToken(res.data['token']);
      await TokenStorage.saveRole(res.data['user']['emp_role']);

      final saved = await TokenStorage.getToken();
      debugPrint('TOKEN SAVED 👉 $saved');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LeadsPage()),
      );
    } on DioException catch (e) {
      debugPrint('DIO ERROR 👉 ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data['message'] ?? 'Login error')),
      );
    } catch (e) {
      debugPrint('UNKNOWN ERROR 👉 $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
