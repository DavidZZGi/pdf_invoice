class Customer {
  final String name;
  final String address;
  final String? customerNo;
  final String? phone;
  final String? email;

  const Customer({
    this.email,
    this.phone,
    this.customerNo,
    required this.name,
    required this.address,
  });
}
