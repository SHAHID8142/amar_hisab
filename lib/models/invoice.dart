class Invoice {
  final String id;
  final String clientName;
  final double amount;
  final DateTime date;
  final bool isPaid;

  Invoice({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.date,
    this.isPaid = false,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      clientName: json['clientName'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      isPaid: json['isPaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'amount': amount,
      'date': date.toIso8601String(),
      'isPaid': isPaid,
    };
  }
}