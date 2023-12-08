class Supplier {
  final String name;
  final String address;
  final String paymentInfo;
  final String? phone;

  const Supplier({
    this.phone,
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}
