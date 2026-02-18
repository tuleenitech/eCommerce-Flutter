import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/product/product_repository.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/enums.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final isLoading = false.obs;
  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await repository.fetchProductsByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        //Default sorting option: Name
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('name');
  }

  // Future<void> searchProducts(String query) async {
  //   try {
  //     final searchQuery = _buildSearchQuery(query);
  //     final searchResults = await fetchProductsByQuery(searchQuery);
  //     assignProducts(searchResults);
  //   } catch (e) {
  //     TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //   }
  // }

  void searchProducts(String query) async {
    isLoading.value = true;
    try {
      final searchResults = await repository.searchProducts(query);
      products.assignAll(searchResults);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  double getProductPrice(ProductModel product) {
  double smallestPrice = double.infinity;
  double largestPrice = 0.0;

  // Single Product
  if (product.productType == ProductType.single.toString()) {
    return product.salePrice > 0 ? product.salePrice : product.price;
  } 
  // Variable Product
  else {
    for (var variation in product.productVariations!) {

      final priceToConsider =
          variation.salePrice > 0.0 ? variation.salePrice : variation.price;

      if (priceToConsider < smallestPrice) {
        smallestPrice = priceToConsider;
      }

      if (priceToConsider > largestPrice) {
        largestPrice = priceToConsider;
      }
    }

    // If all variations same price
    if (smallestPrice == largestPrice) {
      return largestPrice;
    }

    // Return smallest price (UI decides range display)
    return smallestPrice;
  }
}


  // Query _buildSearchQuery(String query) {
  //   return FirebaseFirestore.instance
  //       .collection('products')
  //       .where('title', isGreaterThanOrEqualTo: query)
  //       .where('title', isLessThanOrEqualTo: '$query\uf8ff');
  // }
}
