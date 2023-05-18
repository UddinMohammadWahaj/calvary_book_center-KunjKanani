import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:get/get.dart';

class AudioPlayerService extends GetxService {
  final _player = AudioPlayer();
  var songLength = const Duration(seconds: 0).obs,
      onSongPositionChanged = const Duration(seconds: 0).obs;
  var playerState = PlayerState.stopped.obs;
  var songName = ''.obs, artistName = ''.obs;

  late AlbumModel album;
  bool currentSongIsDownloaded = false;
  var secureFileStorageService = Get.find<SecureFileStorageService>();
  String currentSongUrl = '', currentSongData = '';

  // List<int> currentDownloadedSongData = [];

  var playingIndex = 0;

  @override
  void onInit() {
    const AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.allowAirPlay,
          AVAudioSessionOptions.allowBluetooth,
          AVAudioSessionOptions.allowBluetoothA2DP,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);

    super.onInit();
  }

  Future play({
    required int playingIndex,
  }) async {
    await _setAlbum(playingIndex);

    await _player.play(
      currentSongIsDownloaded
          ? DeviceFileSource(currentSongData)
          : UrlSource(currentSongUrl),
      volume: 1.0,
    );

    // log(_player.source.runtimeType.toString());

    songLength.value =
        await _player.getDuration() ?? const Duration(seconds: 0);

    _player.onDurationChanged.listen((Duration duration) {
      songLength.value = duration;
    });

    _player.onPositionChanged.listen((Duration duration) {
      onSongPositionChanged.value = duration;
    });

    _player.onPlayerComplete.listen((event) async {
      await stop();
      if (album.songs.length - 1 != playingIndex) {
        play(
          playingIndex: playingIndex + 1,
        );
      }
      // TODO: TEST WITH MULTIPLE SONGS
    });

    playerState.value = PlayerState.playing;
  }

  _setAlbum(int playingIndex) async {
    this.playingIndex = playingIndex;

    currentSongIsDownloaded = album.songs[playingIndex].isDownloaded ?? false;

    if (currentSongIsDownloaded) {
      currentSongData = (await secureFileStorageService.getFile(
        fileName: album.songs[playingIndex].songTitle ?? '',
        fileId: album.songs[playingIndex].id,
        fileType: FileType.album,
      ))
          .path;
    } else {
      currentSongUrl = album.songs[playingIndex].song ?? '';
    }

    songName.value = album.songs[playingIndex].songTitle ?? '';
    artistName.value = album.artist ?? '';
  }

  Future pause() async {
    await _player.pause();
    playerState.value = PlayerState.paused;
  }

  Future stop() async {
    playerState.value = PlayerState.stopped;
    await _player.stop();
    // await _clearLocalFiles();
    onSongPositionChanged.value = const Duration(seconds: 0);
    songLength.value = const Duration(seconds: 0);
  }

  Future resume() async {
    await _player.resume();
    playerState.value = PlayerState.playing;
  }

  Future seek(Duration duration) async {
    await _player.seek(duration);
  }

  Future setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future setSpeed(double speed) async {
    await _player.setPlaybackRate(speed);
  }

  Future playOrPause() async {
    if (_player.state == PlayerState.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  void dispose() {
    stop();
    _player.dispose();
  }
}
