class LeadModel {
  final int id;
  final String name;
  final String email;
  final String status;
  final String phone; // Placeholder phone

  LeadModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.phone, // Placeholder phone
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['lead_id'],
      name: json['lead_name'],
      email: json['lead_email'],
      status: json['lead_status'],
      phone: json['lead_phone'] ?? 'N/A', // Placeholder phone
    );
  }
}
