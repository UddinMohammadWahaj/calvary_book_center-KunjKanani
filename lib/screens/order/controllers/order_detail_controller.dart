import 'package:bookcenter/components/order_process.dart';
import 'package:bookcenter/screens/order/controllers/order_controller.dart';
import 'package:bookcenter/screens/order/models/order_model.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  OrderModel currentSelectedOrder = Get.arguments['order'];

  var orderStatus = (Get.arguments['status'] as OrderProcessState).obs;
}
