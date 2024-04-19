import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/data/repositories/user/user_repository.dart';
import 'package:shopping/features/authentication/screens/signup/verify_email.dart';
import 'package:shopping/features/personalization/models/user_model.dart';
import 'package:shopping/utils/helpers/network_manager.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/popups/full_screen_loader.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  //variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  //signup
  void signup() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //privacy policy check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'Inorder to Create Account, you have to read and accept the privacy policy & Terms of Use',
        );
        return;
      }

      //register user in the firebase authentication
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //save user

      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

//show success message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify Email to continue');

      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
