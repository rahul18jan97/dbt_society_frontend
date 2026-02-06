import 'package:dio/dio.dart';

class LeadsRemoteDS {
  final Dio dio;
  LeadsRemoteDS(this.dio);

  Future<List<dynamic>> fetchLeads() async {
    final res = await dio.get('/leads');
    return res.data;
  }
}
