import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AddLeadPage extends StatefulWidget {
  const AddLeadPage({super.key});

  @override
  State<AddLeadPage> createState() => _AddLeadPageState();
}

class _AddLeadPageState extends State<AddLeadPage> {
  final dio = DioClient.dio;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  bool loading = false;
  Future<void> createLead() async {
    debugPrint('Create Lead Started 👉 ${nameCtrl.text}');
    setState(() => loading = true);
    try {
      await dio.post(
        '/leads',
        data: {
          'lead_name': nameCtrl.text,
          'lead_email': emailCtrl.text,
          'lead_phone': phoneCtrl.text,
          'lead_status': 'NEW',

          // Remove assigned_to - backend gets it from req.user
        },
      );
      debugPrint('Create Lead Success 👉 ${nameCtrl.text}');
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Create Lead Failed 👉 ${nameCtrl.text}: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Create failed: ${e.toString()}')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Lead')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : createLead,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
