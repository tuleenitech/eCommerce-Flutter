import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/texts/product_price_text.dart';
import 'package:shopping/features/shop/controllers/product/all_products_controller.dart';
import 'package:shopping/features/shop/screens/product_details/product_detail.dart';

// import 'package:shopping/controllers/all_products_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final AllProductsController controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Search Products',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                controller.searchProducts(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.products.isEmpty) {
                return Center(child: Text('No products found'));
              } else {
                return ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: TProductPriceText(
                          price: controller.getProductPrice(product)),
                    
                      
                      onTap: () {
                        Get.to(() => ProductDetailScreen(product: product));
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
