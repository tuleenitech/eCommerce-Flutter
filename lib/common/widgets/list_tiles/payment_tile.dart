import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping/features/shop/controllers/product/checkout_controller.dart';
import 'package:shopping/features/shop/models/payment_method_model.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/helper_functions.dart';

class TPaymentTile extends StatelessWidget {
  const TPaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;

        Get.back();
      },
      leading: TRoundedContainer(
        width: 60,
        height: 40,
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.light
            : TColors.white,
        padding: const EdgeInsets.all(TSizes.sm),
        child:
            Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
      ),
      title: Text(paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}
