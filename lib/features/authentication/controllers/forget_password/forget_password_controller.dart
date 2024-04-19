import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:shopping/utils/helpers/network_manager.dart';
import 'package:shopping/utils/popups/full_screen_loader.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //send reset password email
  sendPasswordResetEmail() async {
    try {
      // //start loading
      // TFullScreenLoader.openLoadingDialog(
      //     'Logging you in...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google authentication
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link sent to resent your Password'.tr);

      //redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // //start loading
      // TFullScreenLoader.openLoadingDialog(
      //     'Logging you in...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google authentication
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link sent to resent your Password'.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
