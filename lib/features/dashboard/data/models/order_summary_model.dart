import '../../domain/entities/order_summary.dart';

class OrderSummaryModel extends OrderSummary {
  const OrderSummaryModel({
    required super.orderId,
    required super.customerName,
    required super.amount,
    required super.status,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      orderId: json['orderId'] as String,
      customerName: json['customerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'orderId': orderId, 'customerName': customerName, 'amount': amount, 'status': status};
  }

  OrderSummary toEntity() {
    return OrderSummary(
      orderId: orderId,
      customerName: customerName,
      amount: amount,
      status: status,
    );
  }
}
