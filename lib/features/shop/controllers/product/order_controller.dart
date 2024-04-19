import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/common/widgets/success_screen/success_screen.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/data/repositories/orders/order_repository.dart';
import 'package:shopping/features/personalization/controllers/address_controller.dart';
import 'package:shopping/features/shop/controllers/product/cart_controller.dart';
import 'package:shopping/features/shop/controllers/product/checkout_controller.dart';
import 'package:shopping/features/shop/models/order_model.dart';
import 'package:shopping/navigation_menu.dart';
import 'package:shopping/utils/constants/enums.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/popups/full_screen_loader.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  //fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  //Add methods for order processing
  void processOrder(double totalAmount) async {
    try {
      //start loader
      TFullScreenLoader.openLoadingDialog(
          'Processing your Order', TImages.pencilAnimation);

      //get user auth
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      //Add details
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now(),
        items: cartController.cartItems.toList(),
      );

      //save the order
      await orderRepository.saveOrder(order, userId);

      //update the cart
      cartController.clearCart();

      //show Success Screen
      Get.off(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Payment Success!',
            subTitle: 'Your Item will be shipped soon!',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
