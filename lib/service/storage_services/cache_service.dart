import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';

const String kCacheBoxName = 'cacheData';

class CacheService {
  CacheService._();

  /// This is the name of the box where the data will be stored

  static final CacheService instance = CacheService._();

  Future<void> addDataToCache({
    required String apiPath,
    required Map<String, dynamic> data,
    required Duration expiry,
  }) async {
    var box = Hive.box(kCacheBoxName);

    var newStoringData = {
      'apiPath': apiPath,
      'data': jsonEncode(data),
      'expiry': DateTime.now().add(expiry),
    };

    await box.put(apiPath, newStoringData);

    // log('-----------------');
    // log('Data cached');
    // log('-----------------');
    // log('apiPath: $apiPath');
    // // log('data: $data');
    // log('expiry: $expiry');
    // log('-----------------');
  }

  Map<String, dynamic>? getDataFromCache({
    required String apiPath,
  }) {
    var box = Hive.box(kCacheBoxName);

    var data = box.get(apiPath);

    if (data == null) {
      // log('-----------------');
      // log('No data found in cache');
      // log('-----------------');
      // log('apiPath: $apiPath');
      // log('-----------------');
      return null;
    }

    var expiry = data['expiry'] as DateTime;

    if (expiry.isBefore(DateTime.now())) {
      // log('-----------------');
      // log('Data found in cache but expired');
      // log('-----------------');
      // log('apiPath: $apiPath');
      // log('-----------------');
      return null;
    }

    // log('-----------------');
    // log('Data found in cache');
    // log('-----------------');
    // log('apiPath: $apiPath');
    // // log('data: ${data['data']}');
    // log('-----------------');

    return Map<String, dynamic>.from(jsonDecode(data['data']));
  }

  Future<void> deleteDataFromCache({
    required String apiPath,
  }) async {
    var box = Hive.box(kCacheBoxName);

    await box.delete(apiPath);

    // log('-----------------');
    // log('Data deleted from cache');
    // log('-----------------');
    // log('apiPath: $apiPath');
    // log('-----------------');
  }

  Future<void> deleteAllDataFromCache() async {
    var box = Hive.box(kCacheBoxName);
    await box.clear();

    // log('-----------------');
    // log('All data deleted from cache');
    // log('-----------------');
  }

  bool isDataInCache({
    required String apiPath,
  }) {
    var box = Hive.box(kCacheBoxName);

    var data = box.get(apiPath);

    if (data == null) {
      // log('-----------------');
      // log('No data found in cache');
      // log('-----------------');
      // log('apiPath: $apiPath');
      // log('-----------------');
      return false;
    }

    var expiry = data['expiry'] as DateTime;

    if (expiry.isBefore(DateTime.now())) {
      // log('-----------------');
      // log('Data found in cache but expired');
      // log('-----------------');
      // log('apiPath: $apiPath');
      // log('-----------------');
      return false;
    }

    // log('-----------------');
    // log('Data found in cache');
    // log('-----------------');
    // log('apiPath: $apiPath');
    // // log('data: ${data['data']}');
    // log('-----------------');

    return true;
  }
}
