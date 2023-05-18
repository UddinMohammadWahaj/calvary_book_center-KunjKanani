import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  final RxList<ProductModel> cartItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initCartItems();
  }

  void initCartItems() {
    cartItems.value = Get.find<LocalStoragaeService>().getCartValue();
  }

  Future addToCart(ProductModel product, {int? quantity}) async {
    if (_isProductInCart(product)) {
      return await _updateCart(
        product,
        _getProductQuantity(product) + (quantity ?? 1),
      );
    }
    product.buyingQuantity = quantity ?? 1;
    cartItems.add(product);
    return await Get.find<LocalStoragaeService>().updateCartData(cartItems);
  }

  Future removeFromCart(ProductModel product, {fullRemove = false}) async {
    if (_isProductInCart(product)) {
      if (fullRemove) {
        cartItems.remove(product);
        return await Get.find<LocalStoragaeService>().updateCartData(cartItems);
      }

      if (_getProductQuantity(product) > 1) {
        return await _updateCart(product, _getProductQuantity(product) - 1);
      }
    }
  }

  Future clearCart() async {
    cartItems.clear();
    await Get.find<LocalStoragaeService>().clearCartData();
  }

  Future _updateCart(ProductModel product, int quantity) async {
    for (ProductModel element in cartItems) {
      if (element.id == product.id) {
        element.buyingQuantity = quantity;
      }
    }
    await Get.find<LocalStoragaeService>().updateCartData(cartItems);
    cartItems.refresh();
  }

  int getCartCount() {
    int count = 0;
    for (ProductModel element in cartItems) {
      count += element.buyingQuantity ?? 0;
    }
    return count;
  }

  double getCartTotal() {
    double total = 0;
    for (ProductModel element in cartItems) {
      total +=
          element.buyingQuantity ?? 0 * int.parse(element.salePrice ?? '0');
    }
    return total;
  }

  bool _isProductInCart(ProductModel product) {
    for (ProductModel element in cartItems) {
      if (element.id == product.id) {
        return true;
      }
    }
    return false;
  }

  int _getProductQuantity(ProductModel product) {
    for (ProductModel element in cartItems) {
      if (element.id == product.id) {
        return element.buyingQuantity ?? 0;
      }
    }
    return 0;
  }
}
