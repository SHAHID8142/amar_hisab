class Loan {
  final String id;
  final String clientName;
  final double amount;
  final double interestRate;
  final DateTime date;

  Loan({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.interestRate,
    required this.date,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      clientName: json['clientName'],
      amount: json['amount'],
      interestRate: json['interestRate'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'amount': amount,
      'interestRate': interestRate,
      'date': date.toIso8601String(),
    };
  }
}