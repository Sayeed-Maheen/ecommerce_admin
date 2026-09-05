class OrderSummary {
  final String orderId;
  final String customerName;
  final double amount;
  final String status;

  const OrderSummary({
    required this.orderId,
    required this.customerName,
    required this.amount,
    required this.status,
  });
}
