import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/lead_model.dart';

class EditLeadPage extends StatefulWidget {
  final LeadModel lead;
  const EditLeadPage({super.key, required this.lead});

  @override
  State<EditLeadPage> createState() => _EditLeadPageState();
}

class _EditLeadPageState extends State<EditLeadPage> {
  final dio = DioClient.dio;
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.lead.status;
  }

  Future<void> updateLead() async {
    await dio.put('/leads/${widget.lead.id}', data: {'status': status});

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Lead')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: status,
              items: [
                'NEW',
                'IN_PROGRESS',
                'CLOSED',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => status = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateLead, child: const Text('Update')),
          ],
        ),
      ),
    );
  }
}
