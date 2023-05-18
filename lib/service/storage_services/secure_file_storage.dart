import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

enum FileType {
  book,
  sermons,
  album,
}

class SecureFileStorageService extends GetxService {
  var storage = const FlutterSecureStorage();

  // 'TYPE:ID:KEY:FILE NAME:TITLE:AUTHOR'
  Future saveFile({
    required List<int> fileData,
    required String fileName,
    required int fileId,
    required FileType fileType,
    String parentTitle = '',
    String parentImage = '',
    String parentAuthor = '',
    int parentId = 0,
  }) async {
    await _generateAndStoreKey(
      fileId: fileId,
      type: fileType,
      fileName: fileName,
      parentTitle: parentTitle,
      parentImage: parentImage,
      parentAuthor: parentAuthor,
      parentId: parentId,
    );

    await _storeFileSecurly(
      data: fileData,
      fileName: '$fileName.${fileType == FileType.book ? '.pdf' : '.mp3'}',
    );
  }

  Future<Key> _generateAndStoreKey({
    required int fileId,
    required FileType type,
    required String fileName,
    String parentTitle = '',
    String parentImage = '',
    String parentAuthor = '',
    int? parentId,
  }) async {
    final keyBytes = List<int>.generate(
      32,
      (i) => Random.secure().nextInt(256),
    );
    final keyString = base64UrlEncode(keyBytes);
    final key = Key.fromBase64(
      keyString,
    );
    await storage.write(
      key: '${type.name}:$fileId:Key:$fileName',
      value: jsonEncode(
        {
          'key': key.base64,
          'parentId': parentId,
          'parentTitle': parentTitle,
          'parentImage': parentImage,
          'parentAuthor': parentAuthor,
          'fileName': fileName,
          'fileId': fileId,
          'type': type.name,
        },
      ),
    );
    return key;
  }

  Future _readDataFromSecureStorage({
    required String key,
  }) async {
    var keyData = await storage.read(
      key: key,
    );

    return jsonDecode(keyData ?? '{}')['key'];
  }

  Future _storeFileSecurly({
    required List<int> data,
    required String fileName,
  }) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$fileName');

    // dev.log('${dir.path}/$fileName');

    await file.writeAsBytes(data, mode: FileMode.write);

    // dev.log('File saved');

    return;
  }

  Future<File> getFile({
    required String fileName,
    required int fileId,
    required FileType fileType,
  }) async {
    var dir = await getApplicationDocumentsDirectory();
    // dev.log(
    //   '${dir.path}/$fileName.${fileType == FileType.book ? '.pdf' : '.mp3'}',
    // );
    var file = File(
      '${dir.path}/$fileName.${fileType == FileType.book ? '.pdf' : '.mp3'}',
    );

    return file;
  }

  Future<bool> isFileExist({
    required int fileId,
    required FileType fileType,
    required String fileName,
  }) async {
    return await _readDataFromSecureStorage(
          key: '${fileType.name}:$fileId:Key:$fileName',
        ) !=
        null;
  }

  Future<Map<String, dynamic>> getAllFiles() async {
    return await storage.readAll();
  }

  Future deleteAllFiles() async {
    var dir = await getApplicationDocumentsDirectory();
    var files = dir.listSync();
    for (var element in files) {
      if (element is File) {
        element.deleteSync();
      }
    }

    return await storage.deleteAll();
  }

  Future deleteFile({
    required int fileId,
    required FileType fileType,
    required String fileName,
  }) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File(
      '${dir.path}/$fileName.${fileType == FileType.book ? '.pdf' : '.mp3'}',
    );

    await file.delete();

    return await storage.delete(
      key: '${fileType.name}:$fileId:Key:$fileName',
    );
  }
}

// Future<String> encryptFile(Map<String, dynamic> fileData) async {
//   var dir = fileData['directory'] as Directory;
//   // dev.log('${dir.path}/${fileData['fileName']}');

//   var data = fileData['fileData'];

//   var key = fileData['key'] as String;

//   // dev.log('${dir.path}/${fileData['fileName']}' + ' ' + key);

//   // var tmdata = List.castFrom<int, int>(data);

//   // Add key to start and end of file
//   // tmdata.insertAll(0, key.codeUnits);
//   // data.addAll(key.codeUnits);

//   var file = File('${dir.path}/${fileData['fileName']}');

//   await file.writeAsBytes(data, mode: FileMode.append);

//   // List<int> tmdata = await file.readAsBytes();

//   // tmdata.insertAll(0, key.codeUnits);

//   // tmdata.addAll(key.codeUnits);

//   await file.writeAsBytes(key.codeUnits, mode: FileMode.append);

//   // dev.log('File saved');

//   return '';
// }

// Future<List<int>> decryptFile(Map<String, dynamic> fileData) async {
  // final encrypter = Encrypter(
  //   AES(
  //     Key.fromBase64(fileData['key']),
  //   ),
  // );

  // final decrypted = encrypter.decrypt64(
  //   fileData['fileData'],
  //   iv: IV.fromLength(16),
  // );
  // return decrypted;
  // var data = fileData['fileData'] as List<int>;
  // var key = fileData['key'] as String;

  // data = List<int>.from(data);

  // Remove key from start and end of file
  // data.removeRange(0, key.codeUnits.length);
  // data.removeRange(data.length - key.codeUnits.length, data.length);

  // final decrepted = fileData['fileData'].replaceAll(fileData['key'], '');

  // return data;
// }
