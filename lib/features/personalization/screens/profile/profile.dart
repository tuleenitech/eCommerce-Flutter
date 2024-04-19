import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shopping/common/widgets/appbar/appbar.dart';
import 'package:shopping/common/widgets/images/t_circular_image.dart';
import 'package:shopping/common/widgets/texts/section_heading.dart';
import 'package:shopping/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:shopping/features/personalization/controllers/user_controller.dart';
import 'package:shopping/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:shopping/common/widgets/shimmers/shimmer.dart';
import 'package:shopping/utils/constants/image_strings.dart';
import 'package:shopping/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppBar(
        title: TAppBar(
          showBackArrow: true,
          title: Text('Profile'),
        ),
      ),
      //body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            //profile pic
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image =
                        networkImage.isNotEmpty ? networkImage : TImages.user;

                    return controller.imageUploading.value
                        ? const TShimmerEffect(
                            width: 80,
                            height: 80,
                            radius: 80,
                          )
                        : TCircularImage(
                            image: image,
                            width: 80,
                            height: 80,
                            isNetworkImage: networkImage.isNotEmpty,
                          );
                  }),
                  TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'))
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            //Heading Profile Info
            const TSectionHeading(
              title: 'Profile Information',
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
              onPressed: () => Get.to(() => const ChangeName()),
              title: 'name',
              value: controller.user.value.fullName,
            ),
            TProfileMenu(
              onPressed: () {},
              title: 'Username',
              value: controller.user.value.username,
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            //Heading Profile Info
            const TSectionHeading(
              title: 'Personal Information',
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
              title: 'User ID',
              value: controller.user.value.id,
              icon: Iconsax.copy,
              onPressed: () {},
            ),
            TProfileMenu(
              title: 'E-mail',
              value: controller.user.value.email,
              onPressed: () {},
            ),
            TProfileMenu(
              title: 'Phone Number',
              value: controller.user.value.phoneNumber,
              onPressed: () {},
            ),
            TProfileMenu(
              title: 'Gender',
              value: 'Male',
              onPressed: () {},
            ),
            TProfileMenu(
              title: 'Date of Birth',
              value: '10 Oct 1999',
              onPressed: () {},
            ),
            const Divider(),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            Center(
              child: TextButton(
                onPressed: () => controller.deleteAccountWarningPopup(),
                child: const Text(
                  'Close Account',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
