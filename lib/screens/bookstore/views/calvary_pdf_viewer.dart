import 'dart:developer';

import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/controllers/calvary_pdf_viewer_controller.dart';

class CalvaryPdfViewer extends StatefulWidget {
  const CalvaryPdfViewer({super.key});

  @override
  State<CalvaryPdfViewer> createState() => _CalvaryPdfViewerState();
}

class _CalvaryPdfViewerState extends State<CalvaryPdfViewer> {
  late CalvaryPdfViewerController calvaryPdfViewerController;

  @override
  void initState() {
    calvaryPdfViewerController = Get.put(CalvaryPdfViewerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<CalvaryPdfViewerController>(
          builder: (controller) {
            return controller.isFetchingBook.value
                ? const Text('')
                : Text(
                    Get.find<CalvaryPdfViewerController>()
                        .currentBook
                        .bookTitle,
                  );
          },
        ),
        actions: [
          GetX<CalvaryPdfViewerController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.isSearchDialogOpen.value,
                child: IconButton(
                  onPressed: () {
                    controller.toggleSearch();
                  },
                  icon: const Icon(Icons.search),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Page Slider
            GetX<CalvaryPdfViewerController>(
              builder: (controller) {
                return Slider(
                  value: controller.currentPageNumber.value,
                  min: 1,
                  max: controller.pageCount.value.toDouble(),
                  onChanged: (value) {
                    controller.pdfViewerController.jumpToPage(
                      value.toInt(),
                    );
                    controller.currentPageNumber.value = value;
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    var calvaryPdfViewerController =
                        Get.find<CalvaryPdfViewerController>();
                    calvaryPdfViewerController.pdfViewerController
                        .previousPage();
                    calvaryPdfViewerController.currentPageNumber.value =
                        calvaryPdfViewerController
                            .pdfViewerController.pageNumber
                            .toDouble();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () {
                    var calvaryPdfViewerController =
                        Get.find<CalvaryPdfViewerController>();
                    calvaryPdfViewerController.pdfViewerController.nextPage();
                    calvaryPdfViewerController.currentPageNumber.value =
                        calvaryPdfViewerController
                            .pdfViewerController.pageNumber
                            .toDouble();
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GetX<CalvaryPdfViewerController>(
        builder: (controller) {
          // // log(Get.arguments.toString());
          return Column(
            children: [
              Visibility(
                visible: controller.searchToggle.value,
                child: const SizedBox(),
              ),
              // Search TextField
              AnimatedContainer(
                height: controller.isSearchDialogOpen.value ? 55 : 0,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller.searchController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            controller.search();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.isSearchDialogOpen.value,
                      child: PdfActionButton(
                        icon: Icons.close,
                        onPressed: () {
                          if (controller.isSearchDialogOpen.value) {
                            controller.clearSearch();
                          }
                        },
                      ),
                    ),
                    if (controller.isSearching.value)
                      PdfActionButton(
                        onPressed: () {
                          var calvaryPdfViewerController =
                              Get.find<CalvaryPdfViewerController>();
                          calvaryPdfViewerController.result!.previousInstance();
                        },
                        icon: Icons.arrow_back_ios,
                      ),
                    if (controller.isSearching.value)
                      PdfActionButton(
                        onPressed: () {
                          var calvaryPdfViewerController =
                              Get.find<CalvaryPdfViewerController>();
                          calvaryPdfViewerController.result!.nextInstance();
                        },
                        icon: Icons.arrow_forward_ios,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: calvaryPdfViewerController.isFetchingBook.value
                    ? const SpinKitThreeBounce(
                        color: primaryColor,
                        size: 24,
                      )
                    : calvaryPdfViewerController.currentBook.isDownloaded
                        ? SfPdfViewer.memory(
                            calvaryPdfViewerController.downloadedBookData,
                            pageLayoutMode: PdfPageLayoutMode.single,
                            scrollDirection: PdfScrollDirection.horizontal,
                            canShowScrollHead: false,
                            controller: controller.pdfViewerController,
                            onDocumentLoaded:
                                (PdfDocumentLoadedDetails details) {
                              controller.pageCount.value =
                                  details.document.pages.count.toDouble();
                            },
                            currentSearchTextHighlightColor:
                                Colors.red.withOpacity(0.3),
                            otherSearchTextHighlightColor:
                                Colors.yellow.withOpacity(0.3),
                            onPageChanged: (details) {
                              controller.currentPageNumber.value =
                                  details.newPageNumber.toDouble();
                            },
                          )
                        : SfPdfViewer.network(
                            calvaryPdfViewerController.currentBook.paymentStatus ==
                                    'P'
                                ? calvaryPdfViewerController.currentBook.book ??
                                    ''
                                : calvaryPdfViewerController
                                        .currentBook.demoBook ??
                                    '',
                            // 'https://testingdesktivo.blob.core.windows.net/testing/Flutter%20Interview%20Questions%20(2).pdf?sv=2021-10-04&st=2023-04-27T08%3A37%3A34Z&se=2023-04-28T08%3A37%3A34Z&sr=b&sp=r&sig=knJAT%2F2Vlcn0wrHM%2BLoqiRK73m7LoaJiAsGETOlPCyA%3D',
                            pageLayoutMode: PdfPageLayoutMode.single,
                            scrollDirection: PdfScrollDirection.horizontal,
                            canShowScrollHead: false,
                            controller: controller.pdfViewerController,
                            onDocumentLoaded: (
                              PdfDocumentLoadedDetails details,
                            ) async {
                              controller.pageCount.value =
                                  details.document.pages.count.toDouble();
                            },
                            currentSearchTextHighlightColor:
                                Colors.red.withOpacity(0.3),
                            otherSearchTextHighlightColor:
                                Colors.yellow.withOpacity(0.3),
                            onPageChanged: (details) {
                              controller.currentPageNumber.value =
                                  details.newPageNumber.toDouble();
                            },
                            onHyperlinkClicked: (details) {
                              Get.defaultDialog(
                                title: 'Creating Purchase Order',
                                content: Container(
                                  color: Colors.white,
                                  child: const SpinKitThreeBounce(
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                              );

                              var digitalProductPaymentService =
                                  Get.find<DigitalProductPaymentService>();
                              digitalProductPaymentService
                                  .createBookPurchaseOrder(
                                book: controller.currentBook,
                                paymentMadeFrom: PaymentMadeFrom.bookViewer,
                              );
                            },
                            canShowHyperlinkDialog: false,
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PdfActionButton extends StatelessWidget {
  const PdfActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 22,
        ),
      ),
    );
  }
}
