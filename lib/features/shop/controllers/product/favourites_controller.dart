import 'dart:convert';

import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/product/product_repository.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/local_storage/storage_utility.dart';

class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.find();

  //varibles

  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initFavorites();
  }

  void initFavorites() {
    final json = TLocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(
          storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId) {
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      TLoaders.customToast(message: 'Product has been added to the Wishlist');
    } else {
      TLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      TLoaders.customToast(
          message: 'Product has been removed from the Wishlist');
    }
  }

  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    TLocalStorage.instance().writeData('favourites', encodedFavorites);
  }

  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance
        .getFavouriteProducts(favorites.keys.toList());
  }
}
