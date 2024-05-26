import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/brands/brand_card.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/shimmers/brands_shimmer.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/shop/controllers/brand_controller.dart';
import 'package:shopping/features/shop/screens/brands/brand_products.dart';
import 'package:shopping/utils/constants/sizes.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: const TAppBar(title: Text('Brand'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //heading
              const TSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              //brands
              Obx(() {
                // if (brandController.isLoading.value) {
                //   return const TBrandsShimmer();
                // }

                if (brandController.allBrands.isEmpty) {
                  return Center(
                    child: Text('No Data Found!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: Colors.white)),
                  );
                }

                return TGridLayout(
                  itemCount: brandController.allBrands.length,
                  mainAxisExtent: 80,
                  itemBuilder: (_, index) {
                    final brand = brandController.allBrands[index];

                    return TBrandCard(
                      showBorder: true,
                      brand: brand,
                      onTap: () => Get.to(() => BrandProducts(
                            brand: brand,
                          )),
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
