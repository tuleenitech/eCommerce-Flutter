import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/features/personalization/controllers/user_controller.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/constants/text_strings.dart';
import 'package:shopping/utils/validators/validation.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
        appBar: AppBar(title: Text('Re-authenticate User')),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Form(
                key: controller.reAuthFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller.verifyEmail,
                      validator: TValidator.validateEmail,
                      decoration: const InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    // TextFormField
                    Obx(
                      () => TextFormField(
                        obscureText: controller.hidePassword.value,
                        controller: controller.verifyPassword,
                        validator: (value) =>
                            TValidator.validateEmptyText('Password', value),
                        decoration: InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                            icon: const Icon(Iconsax.eye_slash),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    //login btn
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              controller.reAuthenticateEmailAndPasswordUser(),
                          child: const Text('Verify')),
                    )
                  ],
                ),
              )),
        ));
  }
}
