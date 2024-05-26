import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:shopping/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/controllers/category_controller.dart';
import 'package:shopping/features/shop/models/category_model.dart';
import 'package:shopping/features/shop/screens/all_products/all_products.dart';
import 'package:shopping/features/shop/screens/store/widgets/category_brands.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/cloud_helper_function.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                //brands
                CategoryBrands(category: category),
                const SizedBox(height: TSizes.spaceBtwItems),

                //products
                FutureBuilder(
                    future:
                        controller.getCategoryProducts(categoryId: category.id),
                    builder: (context, snapshot) {
                      final response =
                          TCloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot,
                              loader: const TVerticalProductShimmer());
                      if (response != null) return response;

                      final products = snapshot.data!;
                      return Column(
                        children: [
                          TSectionHeading(
                            title: 'You might like',
                            onPressed: () => Get.to(
                              AllProducts(
                                title: category.name,
                                futureMethod: controller.getCategoryProducts(
                                    categoryId: category.id, limit: -1),
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TGridLayout(
                              itemCount: products.length,
                              itemBuilder: (_, index) => TProductCardVertical(
                                  product: products[index])),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ]);
  }
}
