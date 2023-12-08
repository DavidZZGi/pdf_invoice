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
                            fontSize: 12, fontWeight: FontWeight.bold))),
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

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

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
          Text('Telephone: ${supplier.phone!}'),
          // SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      ));

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fist PDF',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Order Quantity',
      'Ship Quantity',
      'Tax',
      'Item Number/Description',
      'Unit Price',
      'Extended Price'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.orderQuantity;

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
      headers: headers,
      data: data,
      border: TableBorder.symmetric(
          outside: const BorderSide(), inside: BorderSide()),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
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

  static Widget buildFooter(Invoice invoice, int pages) => Container(
      padding: const EdgeInsets.only(top: 2),
      width: 200,
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          children: [
            Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Print Date',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Print Time',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Page No',
                  ),
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

  static contactWidget(Customer customer) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Contact: ${customer.name}'),
        Text('Telephone: ${customer.phone}'),
        Text('E-mail: ${customer.email}'),
      ]);

  static tableHeader1(TableData tableData) {
    final headers1 = [
      'Invoice Date',
      'Order Date',
      'SO Number',
      'Ordered By',
      'Costumer PO Number',
      'Payment Method'
    ];

    return Table(border: TableBorder.all(), children: [
      TableRow(
          children: List.generate(
        headers1.length,
        (index) => Column(children: [Text(headers1[index])]),
      )),
      TableRow(children: [
        Column(children: [Text(Utils.formatDate(tableData.invoiceDate))]),
        Column(children: [Text(Utils.formatDate(tableData.orderDate))]),
        Column(children: [Text(tableData.soNumber)]),
        Column(children: [Text(tableData.orderBy)]),
        Column(children: [Text(tableData.customerPoNumber)]),
        Column(children: [Text(tableData.paymentMethod)]),
      ]),
    ]);
  }

  static tableHeader2(TableData tableData) {
    final headers2 = [
      'Warehouse',
      'Ship Via',
      'FOB',
      'Salesperson',
      'Resale Number',
    ];
    return Table(border: TableBorder.all(), children: [
      TableRow(
          children: List.generate(
        headers2.length,
        (index) => Column(children: [Text(headers2[index])]),
      )),
      TableRow(children: [
        Column(children: [Text(tableData.warehouse)]),
        Column(children: [Text(tableData.shipVia)]),
        Column(children: [Text(tableData.fob)]),
        Column(children: [Text(tableData.salesPerson)]),
        Column(children: [Text(tableData.resaleNumber.toString())]),
      ]),
    ]);
  }
}
