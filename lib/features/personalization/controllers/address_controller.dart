import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:http/http.dart";
import "package:shopping/common/widgets/icons/t_circular_icon.dart";
import "package:shopping/common/widgets/loaders/loaders.dart";
import "package:shopping/common/widgets/texts/section_heading.dart";
import "package:shopping/data/repositories/address/address_repository.dart";
import "package:shopping/features/personalization/screens/address/add_new_address.dart";
import "package:shopping/features/personalization/screens/address/widgets/single_address.dart";
import "package:shopping/features/shop/models/address_model.dart";
import "package:shopping/utils/constants/image_strings.dart";
import "package:shopping/utils/constants/sizes.dart";
import "package:shopping/utils/helpers/cloud_helper_function.dart";
import "package:shopping/utils/helpers/network_manager.dart";
import "package:shopping/utils/popups/full_screen_loader.dart";

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;

  // final _db = FirebaseFirestore.instance;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await AddressRepository().fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
          (element) => element.selectedAddress,
          orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      Get.defaultDialog(
        title: '',
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
      );

      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
            selectedAddress.value.id, false);
      }

      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      await addressRepository.updateSelectedField(
          selectedAddress.value.id, true);

      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error in Selection', message: e.toString());
    }
  }

  Future addNewAddress() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Storing Address...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
//form validation
      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //save Address Data
      final address = AddressModel(
          id: '',
          name: name.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          street: street.text.trim(),
          city: city.text.trim(),
          state: name.text.trim(),
          postalCode: postalCode.text.trim(),
          country: country.text.trim(),
          selectedAddress: true);

      final id = await addressRepository.addAddress(address);

      address.id = id;
      await selectAddress(address);

// Remove Loader
      TFullScreenLoader.stopLoading();
// Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations!',
          message: 'Your address has been saved successfully.');

// Refresh Addresses Data
      refreshData.toggle();

// Reset fields
      resetFormFields();

// Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Address not found!', message: e.toString());
    }
  }

  /// Show Addresses ModalBottomSheet ot Checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(TSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TSectionHeading(
                      title: 'Select Address', showActionButton: false),
                  FutureBuilder(
                    future: getAllUserAddresses(),
                    builder: (_, snapshot) {
                      final response =
                          TCloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot);
                      if (response != null) return response;

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => TSingleAddress(
                              address: snapshot.data![index],
                              onTap: () async {
                                await selectAddress(snapshot.data![index]);
                                Get.back();
                              }));
                    },
                  ),
                  const SizedBox(height: TSizes.defaultSpace * 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Get.to(() => const AddNewAddressScreen()),
                      child: const Text('Add new address'),
                    ),
                  )
                ],
              ),
            ));
  }

  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }
}
