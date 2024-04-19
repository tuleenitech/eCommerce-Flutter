import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:shopping/common/widgets/products/sortable/sortable_products.dart';
import 'package:shopping/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:shopping/features/shop/controllers/product/all_products_controller.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/cloud_helper_function.dart';

class AllProducts extends StatelessWidget {
  const AllProducts(
      {super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: TAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
              future: futureMethod ?? controller.fetchProductsByQuery(query),
              builder: (context, snapshot) {
                const loader = TVerticalProductShimmer();

                final widget = TCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                );

                if (widget != null) return widget;

                final products = snapshot.data!;

                return TSortableProducts(products: products);
              }),
        ),
      ),
    );
  }
}
