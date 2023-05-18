import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/bookstore/controllers/book_category_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookStoreCategoryScreen extends StatelessWidget {
  const BookStoreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Category'),
      ),
      body: GetX<BookCategoryController>(
        init: BookCategoryController(),
        builder: (controller) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            controller: controller.scrollController,
            itemCount: controller.isFetchingBookCategories.value
                ? controller.bookCategories.length +
                    getSkeletonCount(
                      length: controller.bookCategories.length,
                    )
                : controller.bookCategories.length,
            itemBuilder: (context, index) {
              if (index >= controller.bookCategories.length &&
                  controller.isFetchingBookCategories.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Skeleton(
                      radious: defaultPadding / 2,
                      height: 35,
                      width: 35,
                    ),
                    SizedBox(height: 10),
                    Skeleton(
                      radious: defaultPadding / 2,
                      height: 12,
                      width: 100,
                    ),
                  ],
                );
              }

              return InkWell(
                onTap: () {
                  Get.toNamed(
                    bookListScreenRoute,
                    arguments: index == 0
                        ? {
                            "id": 0,
                            "name": 'All Categories',
                          }
                        : {
                            "id": controller.bookCategories[index].id,
                            "name":
                                controller.bookCategories[index].categoryTitle,
                          },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 0.7,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.bookCategories[index].categoryIcon !=
                            null)
                          CachedNetworkImage(
                            imageUrl: index == 0
                                ? 'https://img.icons8.com/ios/100/null/open-book--v1.png'
                                : controller
                                        .bookCategories[index].categoryIcon ??
                                    '',
                            width: 35,
                            height: 35,
                          ),
                        if (controller.bookCategories[index].categoryIcon !=
                            null)
                          const SizedBox(height: 10),
                        Text(
                          index == 0
                              ? 'All Categories'
                              : controller.bookCategories[index - 1]
                                      .categoryTitle ??
                                  '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int getSkeletonCount({int length = 1}) {
    if (length % 3 == 0) {
      return 3;
    } else {
      return 3 - (length % 3);
    }
  }
}
