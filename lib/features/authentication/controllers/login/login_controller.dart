import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/features/personalization/controllers/user_controller.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/helpers/network_manager.dart';
import 'package:shopping/utils/popups/full_screen_loader.dart';

class LoginController extends GetxController {
  //variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  //signin
  Future<void> emailAndPasswordSignIn() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //save user
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      //register user in the firebase authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

//remove loader
      TFullScreenLoader.stopLoading();

//redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //google Signin
  //signup
  Future<void> GoogleSignIn() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      //save user record
      await userController.saveUserRecord(userCredentials);

      //remove loader
      TFullScreenLoader.stopLoading();

      //redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
