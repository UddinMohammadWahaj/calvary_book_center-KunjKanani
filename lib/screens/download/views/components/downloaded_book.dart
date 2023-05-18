import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/download/controller/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadedBook extends StatelessWidget {
  const DownloadedBook({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<DownloadController>(
      init: DownloadController(),
      builder: (controller) {
        return controller.downloadedBooks.isEmpty
            ? const EmptyScreen(
                title: "No books downloaded yet",
              )
            : ListView.builder(
                itemCount: controller.downloadedBooks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.navigateToCalvaryPdfViewer(
                        index: index,
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          controller.downloadedBooks[index].bookTitle,
                        ),
                        leading: const Icon(
                          Icons.book,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            controller.deleteDownloadedBook(
                              index: index,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
