class TableData {
  final DateTime invoiceDate;
  final DateTime orderDate;
  final String orderBy;
  final String customerPoNumber;
  final String paymentMethod;
  final String warehouse;
  final String shipVia;
  final String fob;
  final String salesPerson;
  final double resaleNumber;
  final int orderQuantity;
  final int shipQuantity;
  final double tax;
  final String itemNumber;
  final double unitPrice;
  final double extendedPrice;
  final String printDate;
  final String printTime;
  final int pageNumber;
  final String soNumber;

  TableData({
    required this.soNumber,
    required this.invoiceDate,
    required this.orderDate,
    required this.orderBy,
    required this.customerPoNumber,
    required this.paymentMethod,
    required this.warehouse,
    required this.shipVia,
    required this.fob,
    required this.salesPerson,
    required this.resaleNumber,
    required this.orderQuantity,
    required this.shipQuantity,
    required this.tax,
    required this.itemNumber,
    required this.unitPrice,
    required this.extendedPrice,
    required this.printDate,
    required this.printTime,
    required this.pageNumber,
  });
}
