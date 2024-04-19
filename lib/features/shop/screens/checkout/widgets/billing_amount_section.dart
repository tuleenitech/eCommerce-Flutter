import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/products/pricing_calculator.dart';
import 'package:shopping/features/shop/controllers/product/cart_controller.dart';

import 'package:shopping/utils/constants/sizes.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    final subTotal = cartController.totalCartPrice.value;

    return Column(
      children: [
        //subTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SubTotal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$$subTotal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        //shipping fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Fee',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${TPricingCalculator.calculateShippingCost(subTotal, 'US')}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        //Tax fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tax Fee',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${TPricingCalculator.calculateTax(subTotal, 'US')}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        //Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Total',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${TPricingCalculator.calculateTotalPrice(subTotal, 'US')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
