import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl;
  final String targetScreen;
  final bool active;

  BannerModel({
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });

  //convert model to json
  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': imageUrl,
      'TargeScreen': targetScreen,
      "Active": active,
    };
  }

  //map json oriented snapshot
  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    //mao Json record to the model
    return BannerModel(
      imageUrl: data['ImageUrl'] ?? '',
      targetScreen: data['TargeScreen'] ?? '',
      active: data["Active"] ?? false,
    );
  }
}
