import 'dart:convert';
import 'dart:developer';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

const kUserDataBoxName = "UserData";
const kCartBoxName = "CartData";

enum UserField { token, userId, name, email, mobile, isFirstTime }

extension UserFieldExtension on UserField {
  String get asString {
    switch (this) {
      case UserField.token:
        return "token";
      case UserField.userId:
        return "user_id";
      case UserField.name:
        return "name";
      case UserField.email:
        return "email";
      case UserField.mobile:
        return "mobile";
      case UserField.isFirstTime:
        return "is_first_time";
      default:
        return "";
    }
  }
}

enum CartField { cartProducts }

extension CartFieldExtension on CartField {
  String get asString {
    switch (this) {
      case CartField.cartProducts:
        return "cart_products";

      default:
        return "";
    }
  }
}

class LocalStoragaeService extends GetxService {
  late Box userDataBox;
  late Box cartBox;

  Future initBoxes() async {
    if (!Hive.isBoxOpen(kUserDataBoxName)) {
      userDataBox = await Hive.openBox(kUserDataBoxName);
    }
    if (!Hive.isBoxOpen(kCartBoxName)) {
      cartBox = await Hive.openBox(kCartBoxName);
    }
  }

  // Future<bool> deleteUserData() async {
  //   bool isDone = false;
  //   try {
  //     // await userDataBox.clear();

  //     userDataBox.delete("token");
  //     userDataBox.delete("user_id");
  //     userDataBox.delete("name");
  //     userDataBox.delete("email");
  //     userDataBox.delete("mobile");
  //     // log(userDataBox.get("is_first_time").toString());
  //     await cartBox.clear();
  //     isDone = true;
  //   } catch (e) {
  //     // log("$e error");
  //   }
  //   return isDone;
  // }

  Future updateUserData(Map<dynamic, dynamic> userData) async {
    // Using for in loop
    for (var key in userData.keys) {
      await userDataBox.put(key, userData[key].toString());
    }

    // log("${userDataBox.get("token")} token");
  }

  // void updateToken(String token) {
  //   userDataBox.put("token", token);
  // }

  Future clearUserData() async {
    // // log(userDataBox.get("token").toString(), name: "KUNJ");
    await userDataBox.clear();
    await userDataBox.put(UserField.isFirstTime.asString, null);
  }

  dynamic getUserValue(UserField userField) {
    return userDataBox.get(userField.asString);
  }

  // Pass the product list with the quantity
  Future updateCartData(List<ProductModel> cartData) async {
    await cartBox.put('cart_products', json.encode(cartData));
  }

  Future clearCartData() async {
    await cartBox.clear();
  }

  List<ProductModel> getCartValue({CartField? key}) {
    if (key == null) {
      return jsonDecode(cartBox.get('cart_products') ?? '[]')
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList();
    }
    return json.decode(cartBox.get(key.asString) ?? '[]');
  }

  close() async {
    await userDataBox.close();
    await cartBox.close();
  }
}
