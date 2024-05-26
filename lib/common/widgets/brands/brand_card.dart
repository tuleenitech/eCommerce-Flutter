import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shopping/common/widgets/images/t_circular_image.dart';
import 'package:shopping/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:shopping/features/shop/models/brand_model.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/constants/enums.dart';
import 'package:shopping/utils/constants/sizes.dart';
import 'package:shopping/utils/helpers/helper_functions.dart';

class TBrandCard extends StatelessWidget {
  const TBrandCard(
      {super.key, required this.showBorder, this.onTap, required this.brand});

  final BrandModel brand;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      //container design
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //icon
            Flexible(
              child: TCircularImage(
                isNetworkImage: true,
                image: brand.image,
                backgroundColor: Colors.transparent,
                overlayColor: isDark ? TColors.white : TColors.black,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            //text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TBrandTitleWithVerifiedIcon(
                    title: brand.name,
                    brandTextSize: TextSizes.large,
                  ),
                  Text(
                    '${brand.productsCount ?? 0} products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
