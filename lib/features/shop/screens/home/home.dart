import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:shopping/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/controllers/product/product_controller.dart';
import 'package:shopping/features/shop/screens/all_products/all_products.dart';
import 'package:shopping/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shopping/features/shop/screens/home/widgets/home_categories.dart';
import 'package:shopping/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:shopping/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  //header
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections),

                  //searchBar
                  TSearchContainer(text: 'Search in Store', showBorder: false),
                  SizedBox(height: TSizes.spaceBtwSections),

                  //categories

                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBtwItems),

                        //scrollable categories
                        THomeCategories()
                      ],
                    ),
                  ),

                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            //Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  //promo slider
                  const TPromoSlider(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //heading
                  TSectionHeading(
                      title: 'Popular Products',
                      onPressed: () => Get.to(() => AllProducts(
                            title: 'Popular Products',
                            query: FirebaseFirestore.instance
                                .collection('Products')
                                .where('IsFeatured', isEqualTo: true)
                                .limit(6),
                            futureMethod: controller.fetchAllFeaturedProducts(),
                          ))),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //popular products

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const TVerticalProductShimmer();
                    }

                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                          child: Text('No data Found',
                              style: Theme.of(context).textTheme.bodyMedium));
                    }

                    return TGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                          product: controller.featuredProducts[index]),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
