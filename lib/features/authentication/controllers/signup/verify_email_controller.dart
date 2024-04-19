import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shopping/common/widgets/loaders/loaders.dart';
import 'package:shopping/common/widgets/success_screen/success_screen.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/text_strings.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

//send verify email
  @override
  void onInit() {
    // TODO: implement onInit
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  //send link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.errorSnackBar(
          title: 'Email Sent',
          message: 'Please Check your inbox and verify your email');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(
            () => SuccessScreen(
              image: TImages.successfullyRegisterAnimation,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () =>
                  AuthenticationRepository.instance.screenRedirect(),
            ),
          );
        }
      },
    );
  }

  //manually check if email is verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: TImages.successfullyRegisterAnimation,
          title: TTexts.yourAccountCreatedTitle,
          subTitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
