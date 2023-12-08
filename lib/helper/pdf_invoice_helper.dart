import 'dart:io';
import 'package:generate_pdf/helper/pdf_helper.dart';
import 'package:generate_pdf/model/customer.dart';
import 'package:generate_pdf/model/invoice.dart';
import 'package:generate_pdf/model/supplier.dart';
import 'package:generate_pdf/model/table_data.dart';
import 'package:generate_pdf/utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoicePdfHelper {
  static Future<File> generate(Invoice invoice, TableData tableData) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(16),
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        middleWidgetZone(invoice),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        tableHeader1(tableData),
        tableHeader2(tableData),
        buildInvoice(invoice),

        // buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice, context.pageNumber),
    ));

    return PdfHelper.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                child: buildSupplierAddress(invoice.supplier),
              ),
              Column(children: [
                Container(
                    child: Text('Invoice',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))),
                Padding(padding: const EdgeInsets.only(bottom: 20)),
                buildSmallTable(invoice.info.number,
                    invoice.customer.customerNo ?? 'G2 OCEAN'),
              ])
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildSupplierAddress(Supplier supplier) => Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
              const IconData(
                0xe88a,
              ),
              size: 30),
          Padding(padding: const EdgeInsets.only(top: 10)),
          Text(supplier.address),
          Padding(padding: const EdgeInsets.only(top: 10)),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Telephone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ': ${supplier.phone}',
                ),
              ],
            ),
          ),
        ],
      ));

  static Widget buildInvoice(Invoice invoice) {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const cellStyle = TextStyle(fontSize: 11);
    const String orderQuantity = 'Order Quantity';
    const String shipQuantity = 'Ship Quantity';
    const String tax = 'Tax';
    const String itemNumber = 'Item Number/Description';
    const String unitPrice = 'Unit Price';
    const String extendedPrice = 'Extended Price';
    final headers = [
      orderQuantity,
      shipQuantity,
      tax,
      itemNumber,
      unitPrice,
      extendedPrice
    ];

    final data = invoice.items.map((item) {
      return [
        item.orderQuantity,
        item.shipQuantity,
        item.tax,
        item.itemNumber,
        item.unitPrice,
        item.extendedPrice,
      ];
    }).toList();

    return Table.fromTextArray(
      headerDecoration: BoxDecoration(border: Border.all()),
      headers: headers,
      data: data,
      border: const TableBorder(
          verticalInside: BorderSide(),
          bottom: BorderSide(),
          right: BorderSide(),
          left: BorderSide()),
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildFooter(Invoice invoice, int pages) {
    final bold = TextStyle(fontWeight: FontWeight.bold);
    return Container(
        width: 200,
        child: Table(border: TableBorder.all(), children: [
          TableRow(
            children: [
              Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Print Date', style: bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Print Time', style: bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Page No', style: bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      Utils.formatDate(invoice.info.date),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      DateFormat('h:mm:ss a').format(invoice.info.date),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      pages.toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static buildSmallTable(String invoiceNo, String customerNo) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Invoice No.',
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    invoiceNo,
                  ),
                )
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Customer No.',
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    customerNo,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  static middleWidgetZone(Invoice contact) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 90, left: 90),
                        child: Text(
                          'Bill To ',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 10)),
          Container(
              width: 90, height: 70, child: Text(contact.info.description)),
          SizedBox(height: 1 * PdfPageFormat.cm),
          contactWidget(contact.customer),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 90, left: 90),
                        child: Text(
                          'Ship To ',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 10)),
          Container(
              width: 90, height: 70, child: Text(contact.info.description)),
          SizedBox(height: 1 * PdfPageFormat.cm),
          contactWidget(contact.customer),
        ]),
      ]);

  static contactWidget(Customer customer) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ': ${customer.name}',
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Telephone',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ': ${customer.phone}',
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'E-mail',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ': ${customer.email}',
            ),
          ],
        ),
      )
    ]);
  }

  static tableHeader1(TableData tableData) {
    const String invoiceDate = 'Invoice Date';
    const String orderDate = 'Order Date';
    const String soNumber = 'SO Number';
    const String orderBy = 'Ordered By';
    const String customerPoNumber = 'Costumer PO Number';
    const String paymentMethod = 'Payment Method';
    final headers1 = [
      invoiceDate,
      orderDate,
      soNumber,
      orderBy,
      customerPoNumber,
      paymentMethod
    ];
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const cellStyle = TextStyle(fontSize: 11);
    return Table(border: TableBorder.all(), children: [
      TableRow(
          children: List.generate(
        headers1.length,
        (index) =>
            Column(children: [Text(headers1[index], style: headerStyle)]),
      )),
      TableRow(children: [
        Column(children: [
          Text(Utils.formatDate(tableData.invoiceDate), style: cellStyle)
        ]),
        Column(children: [
          Text(Utils.formatDate(tableData.orderDate), style: cellStyle)
        ]),
        Column(children: [Text(tableData.soNumber, style: cellStyle)]),
        Column(children: [Text(tableData.orderBy, style: cellStyle)]),
        Column(children: [Text(tableData.customerPoNumber, style: cellStyle)]),
        Column(children: [Text(tableData.paymentMethod, style: cellStyle)]),
      ]),
    ]);
  }

  static tableHeader2(TableData tableData) {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const cellStyle = TextStyle(fontSize: 11);
    const String warehouse = 'Warehouse';
    const String shipVia = 'Ship Via';
    const String fob = 'FOB';
    const String salesPerson = 'Salesperson';
    const String resaleNumber = 'Resale Number';

    final headers2 = [
      warehouse,
      shipVia,
      fob,
      salesPerson,
      resaleNumber,
    ];
    return Table(border: TableBorder.all(), children: [
      TableRow(
          children: List.generate(
        headers2.length,
        (index) =>
            Column(children: [Text(headers2[index], style: headerStyle)]),
      )),
      TableRow(children: [
        Column(children: [Text(tableData.warehouse, style: cellStyle)]),
        Column(children: [Text(tableData.shipVia, style: cellStyle)]),
        Column(children: [Text(tableData.fob, style: cellStyle)]),
        Column(children: [Text(tableData.salesPerson, style: cellStyle)]),
        Column(children: [
          Text(tableData.resaleNumber.toString(), style: cellStyle)
        ]),
      ]),
    ]);
  }
}
