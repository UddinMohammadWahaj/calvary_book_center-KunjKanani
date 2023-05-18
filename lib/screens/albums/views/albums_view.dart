import 'dart:math';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/albums/controllers/album_view_controller.dart';
import 'package:bookcenter/screens/albums/views/components/song_tile.dart';
import 'package:bookcenter/service/service_elements/player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumView extends StatelessWidget {
  AlbumView({super.key});

  final AlbumViewController controller = Get.put(AlbumViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MusicPlayerTile(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar with large Image
            SliverAppBar(
              stretch: true,
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    background: SizedBox(
                      height: 250,
                      width: 250,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadious,
                          ),
                          child: Hero(
                            tag: controller.currentAlbum.albumLogo ??
                                "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
                            child: Image.network(
                              controller.currentAlbum.albumLogo ??
                                  "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    stretchModes: const [
                      StretchMode.zoomBackground,
                    ],
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: top <= kToolbarHeight + 20 ? 1 : 0,
                      child: Text(
                        controller.currentAlbum.albumTitle ??
                            "currentAlbum Name",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      controller.currentAlbum.albumTitle ?? "currentAlbum Name",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 16,
                              child: Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text(
                              "${controller.songs.length} Songs",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // const Spacer(),
                        // Image.asset(
                        //   "assets/newIcon/share.png",
                        //   color: primaryColor,
                        //   height: 24,
                        //   width: 24,
                        // ),
                        // const SizedBox(
                        //   width: defaultPadding,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(defaultPadding / 2),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          controller.navigateToAlbumPlayer(
                            index: 0,
                            fromStart: true,
                          );
                        },
                        color: primaryColor,
                        height: 40,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadious * 5,
                          ),
                        ),
                        textColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text(
                              "PLAY",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          controller.navigateToAlbumPlayer(
                            index: Random().nextInt(
                              controller.currentAlbum.songs.length,
                            ),
                            fromStart: true,
                          );
                        },
                        color: Colors.white,
                        height: 40,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadious * 5,
                          ),
                          side: const BorderSide(
                            color: primaryColor,
                            width: 1,
                          ),
                        ),
                        textColor: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              CupertinoIcons.shuffle,
                              color: primaryColor,
                              size: 18,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text("SHUFFLE", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.all(defaultPadding),
            ),

            SliverToBoxAdapter(
              child: GetX<AlbumViewController>(
                builder: (albumViewController) {
                  // dev.// log(albumViewController.songs.length.toString());
                  return ListView.builder(
                    itemCount: controller.songs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return SongTile(
                        artiseName: controller.currentAlbum.artist ?? "Artist",
                        index: index,
                        song: albumViewController.songs[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
