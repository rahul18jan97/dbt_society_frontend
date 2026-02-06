import 'package:dbt_society/core/network/dio_client.dart';
import 'package:dbt_society/core/storage/token_storage.dart';
import 'package:dbt_society/features/auth/presentation/pages/login_page.dart';
import 'package:dbt_society/features/leads/presentation/pages/add_lead_page.dart';
import 'package:dbt_society/features/leads/presentation/pages/edit_lead.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/lead_model.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  // final dio = DioClient.createDio();
  // final res = await DioClient.dio.get('/audit');

  List<LeadModel> leads = [];
  bool loading = true;
  String? role;

  @override
  void initState() {
    super.initState();
    loadRole();
    fetchLeads();
  }

  Future<void> loadRole() async {
    final role = await TokenStorage.getRole();
    setState(() => this.role = role);
  }

  Future<void> fetchLeads() async {
    setState(() => loading = true);

    try {
      final token = await TokenStorage.getToken();
      debugPrint('TOKEN BEFORE API 👉 $token');

      final dio = DioClient.dio; // create AFTER token

      final res = await dio.get('/leads');

      debugPrint('LEADS RAW 👉 ${res.data}');

      final List list = res.data as List;

      setState(() {
        leads = list.map((e) => LeadModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('LEADS ERROR 👉 $e');
    } finally {
      setState(() => loading = false);
    }
  }

  // Future<void> loadLeads() async {
  //   try {
  //     final res = await dio.get('/leads');
  //     leads = (res.data as List).map((e) => LeadModel.fromJson(e)).toList();
  //   } catch (e) {
  //     debugPrint('LEADS ERROR $e');
  //   } finally {
  //     setState(() => loading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await TokenStorage.clearToken();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),

      floatingActionButton: role == 'ADMIN'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddLeadPage()),
                );
                if (refresh == true) fetchLeads();
              },
            )
          : null,

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leads.length,
              itemBuilder: (_, i) {
                final l = leads[i];

                return ListTile(
                  title: Text(l.name),
                  subtitle: Text('${l.email} - ${l.phone} - ${l.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (role == 'ADMIN') ...[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final refresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditLeadPage(lead: l),
                              ),
                            );
                            if (refresh == true) fetchLeads();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DioClient.dio.delete('/leads/${l.id}');
                            fetchLeads();
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// class LeadsPage extends StatefulWidget {
//   const LeadsPage({super.key});

//   @override
//   State<LeadsPage> createState() => _LeadsPageState();
// }

// class _LeadsPageState extends State<LeadsPage> {
//   final dio = DioClient.createDio();
//   List<LeadModel> leads = [];
//   bool loading = true;

//   int page = 1;
//   bool hasMore = true;
//   final ScrollController _scrollCtrl = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     loadLeads();
//   }

//   Future<void> loadLeads() async {
//     try {
//       final res = await dio.get('/leads');
//       leads = (res.data as List).map((e) => LeadModel.fromJson(e)).toList();
//     } catch (e) {
//       debugPrint('LEADS ERROR $e');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Leads')),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: leads.length,
//               itemBuilder: (_, i) {
//                 final l = leads[i];
//                 return ListTile(
//                   title: Text(l.name),
//                   subtitle: Text('${l.email} - ${l.phone} - ${l.status}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () async {
//                           final refresh = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => EditLeadPage(lead: l),
//                             ),
//                           );
//                           if (refresh == true) loadLeads();
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () async {
//                           await dio.delete('/leads/${l.id}');
//                           loadLeads();
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
