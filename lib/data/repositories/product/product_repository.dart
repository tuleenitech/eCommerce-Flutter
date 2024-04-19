import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shopping/data/repositories/categories/category_repository.dart';
import 'package:shopping/features/shop/models/product_model.dart';
import 'package:shopping/utils/constants/enums.dart';
import 'package:shopping/utils/exceptions/firebase_exceptions.dart';
import 'package:shopping/utils/exceptions/platform_exceptions.dart';

/// Repository for managing product-related data and operations.
class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  /// Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;

  //get limited featured products
  /// Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(4)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
      return productList;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getFavouriteProducts(
      List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs
          .map((QuerySnapshot) => ProductModel.fromSnapshot(QuerySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForBrand(
      {required String brandId, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
          ? await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .get()
          : await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .limit(limit)
              .get();

      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForCategory(
      {required String categoryId, int limit = 4}) async {
    try {
      QuerySnapshot productCategoryQuery = limit == -1
          ? await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .get()
          : await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .limit(limit)
              .get();

      List<String> productIds = productCategoryQuery.docs
          .map((doc) => doc['productId'] as String)
          .toList();

      final productsQuery = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      List<ProductModel> products = productsQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Upload dummy data to the Cloud Firebase
  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
// Upload all the products along with their images
      final storage = Get.put(TFirebaseStorageService());
// Loop through each product
      for (var product in products) {
// Get image data link from local assets
        final thumbnail =
            await storage.getImageDataFromAssets(product.thumbnail);
// Upload image and get its URL
        final url = await storage.uploadImageData(
            'Products/Images', thumbnail, product.thumbnail.toString());
// Assign URL to product.thumbnail attribute
        product.thumbnail = url;
// Product list of images
        if (product.images != null && product.images!.isNotEmpty) {
          List<String> imagesUrl = [];
          for (var image in product.images!) {
// Get image data Link from local assets
            final assetImage = await storage.getImageDataFromAssets(image);
// Upload image and get its URL
            final url = await storage.uploadImageData(
                'Products/Images', assetImage, image);
            imagesUrl.add(url);
          }
          product.images!.clear();
          product.images!.addAll(imagesUrl);
        }

        if (product.productType == ProductType.variable.toString()) {
          for (var variation in product.productVariations!) {
// Get image data link from local assets
            final assetImage =
                await storage.getImageDataFromAssets(variation.image);
// Upload image and get its URL
            final url = await storage.uploadImageData(
                'Products/Images', assetImage, variation.image);
// Assign URL to variation.image attribute
            variation.image = url;
          }
        }
// Store product in Firestore
        await _db.collection("Products").doc(product.id).set(product.toJson());
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
