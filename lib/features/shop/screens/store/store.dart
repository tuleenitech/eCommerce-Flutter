import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/appbar/tabbar.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:shopping/common/widgets/brands/brand_card.dart';
import 'package:shopping/common/widgets/shimmers/brands_shimmer.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/controllers/brand_controller.dart';
import 'package:shopping/features/shop/controllers/category_controller.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/features/shop/screens/brands/all_brands.dart';
import 'package:shopping/features/shop/screens/brands/brand_products.dart';
import 'package:shopping/features/shop/screens/store/widgets/category_tab.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/helper_functions.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            TCartCounterIcon(),
          ],
        ),
        body: NestedScrollView(
          //header
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: 440,

                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      //search box
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TSearchContainer(
                        text: 'Search in Store',
                        showBackground: false,
                        showBorder: true,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      //Featured Brands
                      TSectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),

//brand grid
                      Obx(() {
                        if (brandController.isLoading.value)
                          return const TBrandsShimmer();

                        if (brandController.featuredBrands.isEmpty) {
                          return Center(
                            child: Text('No Data Found!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(color: Colors.white)),
                          );
                        }

                        return TGridLayout(
                          itemCount: brandController.featuredBrands.length,
                          mainAxisExtent: 80,
                          itemBuilder: (_, index) {
                            final brand = brandController.featuredBrands[index];

                            return TBrandCard(
                              showBorder: true,
                              brand: brand,
                              onTap: () => Get.to(() =>
                                  Get.to(() => BrandProducts(brand: brand))),
                            );
                          },
                        );
                      })
                    ],
                  ),
                ),

                //tabs
                bottom: TTabBar(
                    tabs: categories
                        .map((category) => Tab(child: Text(category.name)))
                        .toList()),
              ),
            ];
          },

          //body section
          body: TabBarView(
            children: categories
                .map((category) => TCategoryTab(category: category))
                .toList(),
          ),
        ),
      ),
    );
  }
}
