import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/images/t_rounded_image.dart';
import 'package:shopping/common/widgets/products/products_cards/product_card_horizontal.dart';
import 'package:shopping/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/controllers/category_controller.dart';
import 'package:shopping/features/shop/models/category_model.dart';
import 'package:shopping/features/shop/screens/all_products/all_products.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/cloud_helper_function.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: TAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //banner
              const TRoundedImage(
                width: double.infinity,
                imageUrl: TImages.banner4,
                applyImageRadius: true,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //Sub-category

              FutureBuilder(
                  future: controller.getSubCategories(category.id),
                  builder: (context, snapshot) {
                    const loader = THorizontalProductShimmer();
                    final widget = TCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    final subCategories = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: subCategories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (__, index) {
                        final subCategory = subCategories[index];

                        return FutureBuilder(
                            future: controller.getCategoryProducts(
                                categoryId: subCategory.id),
                            builder: (context, snapshot) {
                              const loader = THorizontalProductShimmer();
                              final widget =
                                  TCloudHelperFunctions.checkMultiRecordState(
                                      snapshot: snapshot, loader: loader);
                              if (widget != null) return widget;

                              final products = snapshot.data!;

                              return Column(
                                children: [
                                  //heading
                                  TSectionHeading(
                                      title: subCategory.name,
                                      onPressed: () => Get.to(() => AllProducts(
                                            title: subCategory.name,
                                            futureMethod:
                                                controller.getCategoryProducts(
                                                    categoryId: subCategory.id,
                                                    limit: -1),
                                          ))),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems / 2,
                                  ),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.separated(
                                      itemCount: products.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                              width: TSizes.spaceBtwItems),
                                      itemBuilder: (context, index) =>
                                          TProductCardHorizontal(
                                              product: products[index]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwSections,
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
