import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/brands/brand_card.dart';
import 'package:shopping/common/widgets/products/sortable/sortable_products.dart';
import 'package:shopping/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:shopping/features/shop/controllers/brand_controller.dart';
import 'package:shopping/features/shop/models/brand_model.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/cloud_helper_function.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: TAppBar(
        title: Text(brand.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TBrandCard(showBorder: true, brand: brand),
              SizedBox(height: TSizes.spaceBtwSections),
              FutureBuilder(
                  future: controller.getBrandProducts(brandId: brand.id),
                  builder: (context, snapshot) {
                    const loader = TVerticalProductShimmer();
                    final widget = TCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    final BrandProducts = snapshot.data!;
                    return TSortableProducts(products: BrandProducts);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
