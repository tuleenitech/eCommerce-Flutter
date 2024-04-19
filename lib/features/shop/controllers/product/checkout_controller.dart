import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/list_tiles/payment_tile.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/models/payment_method_model.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/sizes.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    selectedPaymentMethod.value =
        PaymentMethodModel(image: TImages.paypal, name: 'Paypal');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(TSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TSectionHeading(
                        title: 'Select Payment Method',
                        showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.paypal, name: 'Paypal'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.googlePay, name: 'Google Pay'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.applePay, name: 'Apple Pay'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod:
                          PaymentMethodModel(image: TImages.visa, name: 'VISA'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.masterCard, name: 'Master Card'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.paytm, name: 'MPesa'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.paystack, name: 'PayStack'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TPaymentTile(
                      paymentMethod: PaymentMethodModel(
                          image: TImages.creditCard, name: 'Credit Card'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                  ],
                ),
              ),
            ));
  }
}
