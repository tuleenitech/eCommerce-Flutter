import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:shopping/common/widgets/icons/t_circular_icon.dart';
import 'package:shopping/common/widgets/images/t_rounded_image.dart';
import 'package:shopping/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shopping/features/shop/controllers/product/images_controller.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/helper_functions.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);

    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            //main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(child: Obx(() {
                  final image = controller.selectedProductImages.value;
                  return GestureDetector(
                    onTap: () => controller.showEnlargedImage(image),
                    child: CachedNetworkImage(
                      imageUrl: image,
                    ),
                  );
                })),
              ),
            ),
            //Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(() {
                    final imageSelected =
                        controller.selectedProductImages.value == images[index];
                    return TRoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        onPressed: () => controller
                            .selectedProductImages.value = images[index],
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        border: Border.all(
                            color: imageSelected
                                ? TColors.primary
                                : Colors.transparent),
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl: images[index]);
                  }),
                ),
              ),
            ),

            //Appbar Icons
            TAppBar(showBackArrow: true, actions: [
              TFavouriteIcon(
                productId: product.id,
              )
            ])
          ],
        ),
      ),
    );
  }
}
