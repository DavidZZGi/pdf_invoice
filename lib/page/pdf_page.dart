import 'package:flutter/material.dart';
import 'package:generate_pdf/helper/pdf_helper.dart';
import 'package:generate_pdf/helper/pdf_invoice_helper.dart';
import 'package:generate_pdf/main.dart';
import 'package:generate_pdf/model/customer.dart';
import 'package:generate_pdf/model/invoice.dart';
import 'package:generate_pdf/model/supplier.dart';
import 'package:generate_pdf/model/table_data.dart';
import 'package:generate_pdf/widget/button_widget.dart';
import 'package:generate_pdf/widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  PdfPageState createState() => PdfPageState();
}

class PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(66, 196, 194, 194),
        appBar: AppBar(
          title: const Text(MyApp.title),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Get PDF',
                  onClicked: () async {
                    final date = DateTime.now();
                    final dueDate = date.add(
                      const Duration(days: 7),
                    );

                    final invoice = Invoice(
                      supplier: const Supplier(
                          name: 'Faysal Neowaz',
                          address:
                              'COE & Company PORT, 4713 Utica St, Metairie, LA 70006',
                          paymentInfo: 'https://paypal.me/codespec',
                          phone: '(504) 885-8686'),
                      customer: const Customer(
                          name: 'COE & Company',
                          address: 'Mountain View, California, United States',
                          email: 'coe@coesolutions.com',
                          phone: '(504) 885-8686'),
                      info: InvoiceInfo(
                        date: date,
                        dueDate: dueDate,
                        description:
                            'G2 OCEAN US, INC 600 GALLERIA PARKWAY SUITE 925 ATLANTA,GA 30339 ',
                        number: '${DateTime.now().year}-9999',
                      ),
                      items: [
                        const InvoiceItem(
                          extendedPrice: 1663473,
                          itemNumber: 'LOAD ST Loading-ST',
                          orderQuantity: 2025.0886,
                          shipQuantity: 2025.0886,
                          tax: 'N',
                          unitPrice: 83200,
                        ),
                        const InvoiceItem(
                          extendedPrice: 2000000,
                          itemNumber: 'Another Item',
                          orderQuantity: 1000,
                          shipQuantity: 950,
                          tax: 'Y',
                          unitPrice: 2000,
                        ),
                        const InvoiceItem(
                          extendedPrice: 1200000,
                          itemNumber: 'Sample Item',
                          orderQuantity: 500,
                          shipQuantity: 500,
                          tax: 'N',
                          unitPrice: 2400,
                        ),
                        const InvoiceItem(
                          extendedPrice: 500000,
                          itemNumber: 'Test Item',
                          orderQuantity: 3000,
                          shipQuantity: 2900,
                          tax: 'Y',
                          unitPrice: 150,
                        ),
                        const InvoiceItem(
                          extendedPrice: 750000,
                          itemNumber: 'Special Item',
                          orderQuantity: 800,
                          shipQuantity: 800,
                          tax: 'N',
                          unitPrice: 937.5,
                        ),
                        const InvoiceItem(
                          extendedPrice: 550600,
                          itemNumber: 'New Item',
                          orderQuantity: 200,
                          shipQuantity: 1800,
                          tax: 'Y',
                          unitPrice: 327.5,
                        ),
                        const InvoiceItem(
                          extendedPrice: 563200,
                          itemNumber: 'Other Item',
                          orderQuantity: 2800,
                          shipQuantity: 5460,
                          tax: 'N',
                          unitPrice: 1247.5,
                        ),
                        const InvoiceItem(
                          extendedPrice: 1003200,
                          itemNumber: 'Expensive Item',
                          orderQuantity: 53000,
                          shipQuantity: 543260,
                          tax: 'N',
                          unitPrice: 42247.5,
                        ),
                        const InvoiceItem(
                          extendedPrice: 43200,
                          itemNumber: 'Cute Item',
                          orderQuantity: 290,
                          shipQuantity: 144943,
                          tax: 'N',
                          unitPrice: 34335.5,
                        ),
                      ],
                    );
                    
                    TableData tableDataInstance = TableData(
                      soNumber: '123456',
                      invoiceDate: DateTime.now(),
                      orderDate: DateTime(2023, 1, 1),
                      orderBy: 'John Doe',
                      customerPoNumber: 'PO123',
                      paymentMethod: 'Credit Card',
                      warehouse: 'Main Warehouse',
                      shipVia: 'UPS',
                      fob: 'FOB Shipping Point',
                      salesPerson: 'Alice Smith',
                      resaleNumber: 12345.67,
                      orderQuantity: 100,
                      shipQuantity: 95,
                      tax: 8.5,
                      itemNumber: 'ITEM123',
                      unitPrice: 25.5,
                      extendedPrice: 2422.5,
                      printDate: '2023-12-01',
                      printTime: '10:30 AM',
                      pageNumber: 1,
                    );

                    final pdfFile = await PdfInvoicePdfHelper.generate(
                        invoice, tableDataInstance);

                    PdfHelper.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
