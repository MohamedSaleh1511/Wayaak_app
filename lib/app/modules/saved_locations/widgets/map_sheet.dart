import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/saved_locations/controllers/saved_locations_controller.dart';

class MapSheet extends GetView<SavedLocationsController> {
  const MapSheet({super.key});

  /// Clean address by removing special characters and extra spaces
  String _cleanAddress(String address) {
    if (address.isEmpty) return address;
    
    // Remove special characters except spaces, commas, and basic characters
    String cleaned = address.replaceAll(RegExp(r'[^\p{L}\p{N}\s,]', unicode: true), '');
    
    // Remove multiple spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    // Remove multiple commas
    cleaned = cleaned.replaceAll(RegExp(r',+'), ',');
    
    // Remove leading/trailing commas and spaces
    cleaned = cleaned.trim().replaceAll(RegExp(r'^,+|,+$'), '');
    
    // Clean up spaces around commas
    cleaned = cleaned.replaceAll(RegExp(r'\s*,\s*'), ', ');
    
    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MapLocationPicker(
        backButton: IconButton(
          onPressed: () => Navigator.of(context).canPop() 
              ? Navigator.of(context).pop() 
              : null,
          icon: "Arrow Back".iconColored(),
        ),
        apiKey: "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc",
        popOnNextButtonTaped: false,
        currentLatLng: (controller.latitude.value == 0.0 &&
                controller.longitude.value == 0.0)
            ? LatLng(controller.currentLocation.value.latitude,
                controller.currentLocation.value.longitude)
            : LatLng(controller.latitude.value, controller.longitude.value),
        debounceDuration: const Duration(milliseconds: 500),
        components: [
          Component(
              Component.country, controller.appServices.userCountryCode.value)
        ],
        region: controller.appServices.userCountryCode.value,
        hideMapTypeButton: true,
        hideMoreOptions: true,
        onNext: (GeocodingResult? result) async {
          if (result != null) {
            controller.latitude.value = result.geometry.location.lat;
            controller.longitude.value = result.geometry.location.lng;
            
            // Get formatted address (street and town only - without gov and country)
            final formattedAddress =
                await controller.getFormattedAddressFromCoordinates(
                    result.geometry.location.lat, 
                    result.geometry.location.lng);
            
            // Clean the address from special characters
            final cleanedAddress = _cleanAddress(formattedAddress);
            
            controller.locationController.text = cleanedAddress.isNotEmpty
                ? cleanedAddress
                : _cleanAddress(result.formattedAddress ?? '');
            
            // Use Navigator.pop instead of Get.back
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        onDecodeAddress: (GeocodingResult? result) async {
          if (result != null) {
            // Update address in real-time when user moves the map marker or clicks on map
            // This shows the formatted address (street and town only) above the "Select Location" button
            final formattedAddress =
                await controller.getFormattedAddressFromCoordinates(
                    result.geometry.location.lat, 
                    result.geometry.location.lng);
            
            // Clean the address from special characters
            final cleanedAddress = _cleanAddress(formattedAddress);
            
            if (cleanedAddress.isNotEmpty) {
              controller.locationController.text = cleanedAddress;
            }
            debugPrint('Real-time address update: $cleanedAddress');
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) async {
          if (result != null && result.result != null) {
            // When user selects from search suggestions
            final lat = result.result!.geometry?.location.lat;
            final lng = result.result!.geometry?.location.lng;
            
            if (lat != null && lng != null) {
              // Get formatted address (street and town only)
              final formattedAddress = await controller
                  .getFormattedAddressFromCoordinates(lat, lng);
              
              // Clean the address from special characters
              final cleanedAddress = _cleanAddress(formattedAddress);
              
              if (cleanedAddress.isNotEmpty) {
                controller.locationController.text = cleanedAddress;
              }
              debugPrint('Selected suggestion address: $cleanedAddress');
            }
          }
        },
      );
    });
  }
}