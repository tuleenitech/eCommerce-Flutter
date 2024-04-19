import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/styles/shadows.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping/common/widgets/icons/t_circular_icon.dart';
import 'package:shopping/common/widgets/images/t_rounded_image.dart';
import 'package:shopping/common/widgets/products/cart/add_to_cart_button.dart';
import 'package:shopping/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shopping/common/widgets/texts/product_price_text.dart';
import 'package:shopping/common/widgets/texts/product_title_text.dart';
import 'package:shopping/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:shopping/features/shop/controllers/product/product_controller.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/features/shop/screens/product_details/product_detail.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/constants/enums.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/helper_functions.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);

//container with side paddings

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(children: [
          //thumbnail
          TRoundedContainer(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(TSizes.sm),
            backgroundColor: dark ? TColors.dark : TColors.light,
            child: Stack(
              children: [
                //thumbnail img
                Center(
                  child: TRoundedImage(
                    imageUrl: product.thumbnail,
                    applyImageRadius: true,
                    isNetworkImage: true,
                  ),
                ),

                //sale Tag
                if (salePercentage != null)
                  Positioned(
                    top: 12,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: TColors.secondary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm, vertical: TSizes.xs),
                      child: Text('$salePercentage%',
                          style: Theme.of(context).textTheme.labelLarge!.apply(
                                color: TColors.black,
                              )),
                    ),
                  ),

                //favorite Icon btn
                Positioned(
                  top: 0,
                  right: 0,
                  child: TFavouriteIcon(
                    productId: product.id,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems / 2),

          //details
          Padding(
            padding: EdgeInsets.only(left: TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TProductTitleText(title: product.title, smallSize: true),
                SizedBox(height: TSizes.spaceBtwItems / 2),
                TBrandTitleWithVerifiedIcon(
                  title: product.brand!.name,
                ),
              ],
            ),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //price
              Flexible(
                child: Column(
                  children: [
                    if (product.productType == ProductType.single.toString() &&
                        product.salePrice > 0)
                      Padding(
                        padding: EdgeInsets.only(left: TSizes.sm),
                        child: Text(
                          product.price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    //price
                    Padding(
                      padding: EdgeInsets.only(left: TSizes.sm),
                      child: TProductPriceText(
                          price: controller.getProductPrice(product)),
                    ),
                  ],
                ),
              ),

              //add to cart btn
              TProductCardAddToCartButton(product: product)
            ],
          )
        ]),
      ),
    );
  }
}
