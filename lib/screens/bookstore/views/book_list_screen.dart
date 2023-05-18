import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/service/service_elements/book_payment_bottom_sheet.dart';
import 'package:bookcenter/screens/bookstore/views/components/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bookcenter/components/piil_button.dart';
import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/controllers/book_list_controller.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.put(BookListController()).bookCategoryName),
      ),
      body: GetX<BookListController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                  controller: controller.languageScrollController,
                  itemCount: controller.isFetchingLanguages.value
                      ? controller.languages.length + 1
                      : controller.languages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index >= controller.languages.length &&
                        controller.isFetchingLanguages.value) {
                      return const Skeleton(
                        width: 120,
                      );
                    }

                    return PillButton(
                      text: controller.languages[index].languageTitle ?? '',
                      isActive: controller.selectedLanguageIndex.value == index,
                      press: () {
                        if (controller.selectedLanguageIndex.value == index) {
                          return;
                        }

                        controller.selectedLanguageIndex.value = index;
                        controller.initFetchBooks();
                      },
                      margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 4,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: defaultPadding),
              // _buildFilter(controller),
              // const SizedBox(height: defaultPadding),
              !controller.isFetchingBooks.value && controller.books.isEmpty
                  ? const EmptyScreen(
                      title: "No Books Found",
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          controller: controller.scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: defaultPadding / 2,
                            mainAxisSpacing: defaultPadding / 2,
                          ),
                          itemCount: controller.isFetchingBooks.value
                              ? controller.books.length + 4
                              : controller.books.length,
                          itemBuilder: (context, index) {
                            if (index >= controller.books.length &&
                                controller.isFetchingBooks.value) {
                              return const Skeleton();
                            }

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                BookTile(
                                  id: controller.books[index].id,
                                  index: index,
                                  image: controller.books[index].bookLogo ?? '',
                                  brandName: 'Calvary',
                                  title: controller.books[index].bookTitle,
                                  price: double.parse(
                                    controller.books[index].price ?? '0.0',
                                  ),
                                  isPurchased:
                                      controller.books[index].paymentStatus ==
                                          'P',
                                  press: () {
                                    showModalBottomSheet(
                                      context: context,
                                      constraints: BoxConstraints(
                                        maxHeight: Get.width * 1.8,
                                        minHeight: Get.width * 1.8,
                                      ),
                                      isDismissible: false,
                                      enableDrag: false,
                                      builder: (context) {
                                        return BookPaymentBottomSheet(
                                          book: controller.books[index],
                                          onPressedDownload: () {
                                            var controller =
                                                Get.find<BookListController>();
                                            controller.downloadBook(
                                              bookId:
                                                  controller.books[index].id,
                                              bookUrl:
                                                  controller.books[index].book!,
                                              bookName: controller
                                                  .books[index].bookTitle,
                                            );
                                            Get.back();
                                          },
                                        );
                                      },
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Container _buildFilter(BookListController controller) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                controller.isFree.value ? defaultPadding / 2 : Get.width * 0.31,
            right:
                controller.isFree.value ? Get.width * 0.31 : defaultPadding / 2,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadious,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  controller.isFree.value = true;
                  controller.initFetchBooks();
                },
                child: SizedBox(
                  width: Get.width * 0.3,
                  child: Text(
                    "Free",
                    style: TextStyle(
                      color:
                          controller.isFree.value ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.isFree.value = false;
                  controller.initFetchBooks();
                },
                child: SizedBox(
                  width: Get.width * 0.3,
                  child: Text(
                    "Paid",
                    style: TextStyle(
                      color:
                          controller.isFree.value ? Colors.black : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
