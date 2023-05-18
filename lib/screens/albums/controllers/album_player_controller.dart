import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:get/get.dart';

class AlbumPlayerController extends GetxController {
  final audioPlayerService = Get.find<AudioPlayerService>();

  late Rx<AlbumModel> currentAlbum;

  var songProgress = 0.obs,
      songDuration = 0.obs,
      isLoadingSong = true.obs,
      currentSongIndex = 0.obs;

  var playerState = PlayerState.stopped.obs;

  @override
  void onReady() {
    audioPlayerService.songLength.listenAndPump((event) {
      songDuration.value = event.inSeconds;
    });

    audioPlayerService.playerState.listenAndPump((state) {
      playerState.value = state;
    });

    audioPlayerService.onSongPositionChanged.listenAndPump((event) {
      songProgress.value = event.inSeconds;
    });

    super.onReady();
  }

  @override
  void onInit() {
    currentAlbum = audioPlayerService.album.obs;
    super.onInit();
  }

  void playSong(int index) async {
    currentSongIndex.value = index;

    isLoadingSong.value = true;

    await audioPlayerService.play(
      playingIndex: index,
    );

    isLoadingSong.value = false;
  }

  Future stopPlayer() async {
    if (playerState.value == PlayerState.playing) {
      await audioPlayerService.stop();
    }
    // log('STOP END');
  }

  void disposePlayer() {
    audioPlayerService.dispose();
    playerState.value = PlayerState.stopped;
    songProgress.value = 0;
    songDuration.value = 0;
    currentSongIndex.value = 0;
  }

  void seekTo(int int) {
    audioPlayerService.seek(Duration(seconds: int));
  }

  void playNextSong() async {
    int newIndex =
        ((currentSongIndex.value + 1.0) % currentAlbum.value.songs.length)
            .toInt();
    await stopPlayer();
    playSong(newIndex);
  }

  void playPreviousSong() async {
    int newIndex =
        ((currentSongIndex.value - 1.0) % currentAlbum.value.songs.length)
            .toInt();
    await stopPlayer();
    playSong(newIndex);
  }

  void playOrPause() async {
    await audioPlayerService.playOrPause();
  }
}
