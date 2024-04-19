import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/sizes.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  RxString selectedProductImages = ''.obs;

  List<String> getAllProductImages(ProductModel product) {
    Set<String> images = {};

    images.add(product.thumbnail);
    selectedProductImages.value = product.thumbnail;

    if (product.images != null) {
      images.addAll(product.images!);
    }

    if (product.productVariations != null ||
        product.productVariations!.isNotEmpty) {
      images.addAll(
          product.productVariations!.map((variation) => variation.image));
    }

    return images.toList();
  }

  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: TSizes.defaultSpace * 2,
                  horizontal: TSizes.defaultSpace),
              child: CachedNetworkImage(imageUrl: image),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: () => Get.back(), child: const Text('Close')),
              ), // SizedBox
            ), // Align
          ],
        ), // Coluen
      ),
    );
  }
}
