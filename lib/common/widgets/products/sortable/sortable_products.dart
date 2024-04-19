import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/widgets/layout/grid_layout.dart';
import 'package:shopping/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:shopping/features/shop/controllers/product/all_products_controller.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/sizes.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);
    return Column(
      children: [
        //dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          items: [
            'name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity'
          ]
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) {
            controller.sortProducts(value!);
          },
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Products
        Obx(
          () => TGridLayout(
              itemCount: controller.products.length,
              itemBuilder: (_, index) => TProductCardVertical(
                    product: controller.products[index],
                  )),
        )
      ],
    );
  }
}
