import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/categories/category_repository.dart';
import 'package:shopping/data/repositories/product/product_repository.dart';
import 'package:shopping/features/shop/models/category_model.dart';
import 'package:shopping/features/shop/models/product_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchCategories();
    super.onInit();
  }

  //load category data
  Future<void> fetchCategories() async {
    try {
      // show loader
      isLoading.value = true;

      //fetch categories
      final categories = await _categoryRepository.getAllCategories();

      //update
      allCategories.assignAll(categories);

      //filter featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      //remove loader
      isLoading.value = false;
    }
  }

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories =
          await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryProducts(
      {required String categoryId, int limit = 4}) async {
    try {
      final products = await ProductRepository.instance
          .getProductsForCategory(categoryId: categoryId, limit: limit);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
}
