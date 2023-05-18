import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/download/controller/download_controller.dart';
import 'package:bookcenter/screens/download/views/components/ribben_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadedSermon extends StatelessWidget {
  const DownloadedSermon({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<DownloadController>(
      builder: (controller) {
        return controller.downloadedSermons.isEmpty
            ? const EmptyScreen(
                title: "No sermons downloaded yet",
              )
            : ListView.builder(
                itemCount: controller.downloadedSermons.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.navigateToSermonViewer(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: controller
                                        .downloadedSermons[index].sermonsLogo ??
                                    '',
                                width: 75,
                                height: 75,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.downloadedSermons[index]
                                          .sermonsTitle ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Text(
                                  controller.downloadedSermons[index]
                                          .sermonsArtist ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 3,
                                ),
                                const RibbenWidget(),
                              ],
                            ),
                            const Spacer(),
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.delete_forever,
                            //     color: primaryColor,
                            //     size: 30,
                            //   ),
                            //   onPressed: () {
                            //     controller.deleteSermon(
                            //       index: index,
                            //     );
                            //   },
                            // ),
                          ],
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
