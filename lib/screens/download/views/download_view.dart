import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/download/views/components/downloaded_album.dart';
import 'package:bookcenter/screens/download/views/components/downloaded_book.dart';
import 'package:bookcenter/screens/download/views/components/downloaded_sermon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              indicatorColor: primaryColor,
              tabs: [
                Tab(
                  icon: Image.asset(
                    "assets/newIcon/book.png",
                    width: 26,
                    height: 26,
                  ),
                  child: const Text(
                    'Books',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    "assets/newIcon/music.png",
                    width: 26,
                  ),
                  child: const Text(
                    'Albums',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    "assets/newIcon/video.png",
                    width: 26,
                  ),
                  child: const Text(
                    'Sermons',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                DownloadedBook(),
                DownloadedAlbum(),
                DownloadedSermon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
