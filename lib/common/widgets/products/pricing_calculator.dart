class TPricingCalculator {
  static double calculateTotalPrice(double subTotal, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = subTotal * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = subTotal * taxAmount * shippingCost;

    return totalPrice;
  }

//calculate shipping cost
  static String calculateShippingCost(double subTotal, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  ///--Calculate tax
  static String calculateTax(double subTotal, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = subTotal * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  static double getTaxRateForLocation(String location) {
// Lookup the tax rate for the given location free a tax rate database or API.
// Return the appropriate tax rate.
    return 0.10; // Example tax rate of 10%
  }

  static double getShippingCost(String location) {
// Lukup the shipping cost for the given location using a shipping rate AFI.
// Calculate the shipping cost based on various factors Like distance, weight, etc.
    return 5.00; // Example shipping cost of $5
  }
}
