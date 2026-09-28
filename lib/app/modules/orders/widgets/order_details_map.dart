import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:wayaak/app/modules/orders/controllers/orders_controller.dart';

class OrderDetailsMap extends StatefulWidget {
  final LatLng sourceLocation;
  final LatLng destinationLocation;

  const OrderDetailsMap({
    super.key,
    required this.sourceLocation,
    required this.destinationLocation,
  });

  @override
  State<OrderDetailsMap> createState() => _OrderDetailsMapState();
}

class _OrderDetailsMapState extends State<OrderDetailsMap> {
  final locationController = Location();
  final OrdersController ordersController = Get.find<OrdersController>();
  late GoogleMapController mapController;

  void _moveCameraToFitBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.sourceLocation.latitude < widget.destinationLocation.latitude
            ? widget.sourceLocation.latitude
            : widget.destinationLocation.latitude,
        widget.sourceLocation.longitude < widget.destinationLocation.longitude
            ? widget.sourceLocation.longitude
            : widget.destinationLocation.longitude,
      ),
      northeast: LatLng(
        widget.sourceLocation.latitude > widget.destinationLocation.latitude
            ? widget.sourceLocation.latitude
            : widget.destinationLocation.latitude,
        widget.sourceLocation.longitude > widget.destinationLocation.longitude
            ? widget.sourceLocation.longitude
            : widget.destinationLocation.longitude,
      ),
    );

    // Animate the camera to fit both locations
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  void initState() {
    super.initState();
    ordersController.createDirectionsPolyline(
      currentLoc: widget.sourceLocation,
      destinationLoc: widget.destinationLocation,
    );
    Get.log(
        "Source:: ${widget.sourceLocation.latitude},${widget.sourceLocation.longitude}");
    Get.log(
        "Destination:: ${widget.destinationLocation.latitude},${widget.destinationLocation.longitude}");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(
          () {
            if (ordersController.isPolyline.value) {
              return Center(
                child:
                    Lottie.asset('assets/lotties/dots-loader.json', width: 80),
              );
            } else {
              return GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  _moveCameraToFitBounds();
                },
                initialCameraPosition: CameraPosition(
                  target: widget.sourceLocation,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('sourceLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: widget.sourceLocation,
                  ),
                  Marker(
                    markerId: const MarkerId('destinationLocation'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    position: widget.destinationLocation,
                  )
                },
                polylines:
                    Set<Polyline>.of(ordersController.polylines.value.values),
              );
            }
          },
        ),
      );
}
