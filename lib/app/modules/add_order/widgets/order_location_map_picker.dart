import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';
import 'package:wayaak/app/modules/add_order/controllers/add_order_controller.dart';
import 'package:wayaak/app/modules/saved_locations/bindings/saved_locations_binding.dart';
import 'package:wayaak/app/modules/saved_locations/controllers/saved_locations_controller.dart';
import 'package:wayaak/app/modules/saved_locations/widgets/saved_locations_bottom_sheet.dart';

class OrderLocationMapPicker extends StatefulWidget {
  final int locationType; // 0 for current, 1 for destination
  const OrderLocationMapPicker({super.key, required this.locationType});

  @override
  State<OrderLocationMapPicker> createState() => _OrderLocationMapPickerState();
}

class _OrderLocationMapPickerState extends State<OrderLocationMapPicker> {
  LatLng? _initialLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Clean address by removing special characters and extra spaces
  String _cleanAddress(String address) {
    if (address.isEmpty) return address;

    // Remove special characters except spaces, commas, and basic characters
    String cleaned =
        address.replaceAll(RegExp(r'[^\p{L}\p{N}\s,]', unicode: true), '');

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

  Future<void> _initializeLocation() async {
    // Initialize SavedLocationsController and its dependencies if not already initialized
    if (!Get.isRegistered<SavedLocationsController>()) {
      SavedLocationsBinding().dependencies();
    }

    final addOrderController = Get.find<AddOrderController>();
    final savedLocationsController = Get.find<SavedLocationsController>();

    // First, check if there's a pre-selected location for this type
    if (widget.locationType == 0 &&
        addOrderController.currentLocation.value.latitude != null &&
        addOrderController.currentLocation.value.latitude!.isNotEmpty) {
      try {
        _initialLocation = LatLng(
          double.parse(addOrderController.currentLocation.value.latitude!),
          double.parse(addOrderController.currentLocation.value.longitude!),
        );
        setState(() => _isLoading = false);
        return;
      } catch (e) {
        debugPrint('Error parsing pre-selected current location: $e');
      }
    } else if (widget.locationType == 1 &&
        addOrderController.destinationLocation.value.latitude != null &&
        addOrderController.destinationLocation.value.latitude!.isNotEmpty) {
      try {
        _initialLocation = LatLng(
          double.parse(addOrderController.destinationLocation.value.latitude!),
          double.parse(addOrderController.destinationLocation.value.longitude!),
        );
        setState(() => _isLoading = false);
        return;
      } catch (e) {
        debugPrint('Error parsing pre-selected destination location: $e');
      }
    }

    try {
      // Try to initialize current location from GPS
      if (savedLocationsController.currentLocation.value.latitude == 0.0 &&
          savedLocationsController.currentLocation.value.longitude == 0.0) {
        await savedLocationsController.initializeLocation();
      }

      // Set initial location to current GPS location (or default if permission denied)
      if (savedLocationsController.currentLocation.value.latitude != 0.0 &&
          savedLocationsController.currentLocation.value.longitude != 0.0) {
        _initialLocation = LatLng(
          savedLocationsController.currentLocation.value.latitude,
          savedLocationsController.currentLocation.value.longitude,
        );
      } else {
        // Fallback to a default location (e.g., Cairo, Egypt)
        _initialLocation = const LatLng(30.0444, 31.2357);
        debugPrint(
            'Using default location (permission denied or not available)');
      }
    } catch (e) {
      // If any error occurs during initialization, use default location
      _initialLocation = const LatLng(30.0444, 31.2357);
      debugPrint(
          'Error during location initialization: $e, using default location');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _initialLocation == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              'Getting your location...'.tr.body(),
            ],
          ),
        ),
      );
    }

    final addOrderController = Get.find<AddOrderController>();
    final savedLocationsController = Get.find<SavedLocationsController>();

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press safely
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            MapLocationPicker(
              backButton: IconButton(
                onPressed: () {
                  // Use Navigator.pop instead of Get.back to avoid snackbar conflict
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                icon: "Arrow Back".iconColored(),
              ),
              apiKey: "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc",
              popOnNextButtonTaped: false,
              currentLatLng: _initialLocation!,
              debounceDuration: const Duration(milliseconds: 500),
              components: [
                Component(
                  Component.country,
                  savedLocationsController.appServices.userCountryCode.value,
                )
              ],
              region:
                  savedLocationsController.appServices.userCountryCode.value,
              hideMapTypeButton: true,
              hideMoreOptions: true,
              onNext: (GeocodingResult? result) async {
                if (result != null) {
                  log("resspinss ${result}");
                  // Get formatted address (street and town only)
                  final formattedAddress = await savedLocationsController
                      .getFormattedAddressFromCoordinates(
                    result.geometry.location.lat,
                    result.geometry.location.lng,
                  );

                  // Clean the address from special characters
                  final cleanedAddress = _cleanAddress(formattedAddress);

                  // Create location datum from selected location (without id since it's a new selection)
                  final locationDatum = addOrderController.createLocationDatum(
                    title: cleanedAddress.isNotEmpty
                        ? cleanedAddress
                        : _cleanAddress(result.formattedAddress ?? ''),
                    latitude: result.geometry.location.lat,
                    longitude: result.geometry.location.lng,
                  );

                  // Update the appropriate location based on type
                  if (widget.locationType == 0) {
                    addOrderController.currentLocation.value = locationDatum;
                  } else {
                    addOrderController.destinationLocation.value =
                        locationDatum;
                  }

                  // Use Navigator.pop instead of Get.back
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              },
              onDecodeAddress: (GeocodingResult? result) async {
                log("onDecodeAddress ${result}");
                if (result != null) {
                  // Update address in real-time when user moves the map marker or clicks on map
                  final formattedAddress = await savedLocationsController
                      .getFormattedAddressFromCoordinates(
                    result.geometry.location.lat,
                    result.geometry.location.lng,
                  );

                  // Clean the address from special characters
                  final cleanedAddress = _cleanAddress(formattedAddress);

                  // This updates the address text shown above the "Select Location" button
                  // The map_location_picker package will display this formatted address
                  debugPrint('Formatted address: $cleanedAddress');
                }
              },
              onSuggestionSelected: (PlacesDetailsResponse? result) async {
                if (result?.result != null) {
                  // When user selects from search suggestions
                  final lat = result!.result.geometry?.location.lat;
                  final lng = result.result.geometry?.location.lng;

                  if (lat != null && lng != null) {
                    // Get formatted address (street and town only)
                    final formattedAddress = await savedLocationsController
                        .getFormattedAddressFromCoordinates(lat, lng);

                    // Clean the address from special characters
                    final cleanedAddress = _cleanAddress(formattedAddress);

                    debugPrint('Selected suggestion address: $cleanedAddress');
                  }
                }
              },
            ),
            // Saved locations FAB positioned above current location button
            Positioned(
              top:
                  100, // Position above the current location button (which is at bottom: 16 with 8px padding)
              right: 8,
              child: FloatingActionButton(
                heroTag: 'savedLocationsBtn', // Add unique hero tag
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    builder: (bottomSheetContext) => SavedLocationsBottomSheet(
                      locationType: widget.locationType,
                      onLocationSelected: () {
                        // Close the map picker when a location is selected
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                  );
                },
                backgroundColor: Get.theme.primaryColor,
                child: 'star'.iconColored(color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
