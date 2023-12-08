import 'package:generate_pdf/model/customer.dart';
import 'package:generate_pdf/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final double orderQuantity;
  final double shipQuantity;
  final String tax;
  final String itemNumber;
  final double unitPrice;
  final double extendedPrice;

  const InvoiceItem(
      {required this.extendedPrice,
      required this.itemNumber,
      required this.orderQuantity,
      required this.shipQuantity,
      required this.unitPrice,
      required this.tax});
}
