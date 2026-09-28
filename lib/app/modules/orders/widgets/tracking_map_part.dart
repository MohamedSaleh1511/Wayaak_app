import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:wayaak/app/data/services/socket_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LiveTrackingMap extends StatefulWidget {
  final LatLng sourceLocation;
  final LatLng destinationLocation;

  const LiveTrackingMap({
    super.key,
    required this.sourceLocation,
    required this.destinationLocation,
  });

  @override
  createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap> {
  final SocketServices socketServices = Get.find<SocketServices>();
  final PolylinePoints polylinePoints = PolylinePoints();

  late BitmapDescriptor customDriverIcon;
  late BitmapDescriptor customDestinationIcon;
  late BitmapDescriptor customCurrentIcon;

  final Map<MarkerId, Marker> markers = {};
  final Map<PolylineId, Polyline> polylines = {};

  LatLng? currentDriverLocation;
  LatLng? previousDriverLocation;
  double bearing = 0.0;

  Timer? polylineUpdateTimer;
  final double movementThreshold = 0.0005; // Adjust as needed

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCustomMarkers();
    _addFixedMarkers();
    _listenToDriverLocation();
    _startPolylineUpdater();
  }

  Future<void> _loadCustomMarkers() async {
    customDriverIcon =
        await _createCustomMarkerBitmap('assets/images/markercar.png', 25);
    customDestinationIcon =
        await _createCustomMarkerBitmap('assets/images/dest.png', 25);
    customCurrentIcon =
        await _createCustomMarkerBitmap('assets/images/flag.png', 35);
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      String assetPath, int size) async {
    final ByteData imageData = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: size,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();
    return BitmapDescriptor.bytes(resizedImageData);
  }

  void _addFixedMarkers() {
    const MarkerId sourceMarkerId = MarkerId('source');
    const MarkerId destinationMarkerId = MarkerId('destination');

    markers[sourceMarkerId] = Marker(
      markerId: sourceMarkerId,
      position: widget.sourceLocation,
      icon: customCurrentIcon,
      infoWindow: InfoWindow(
        title: 'Source Location',
        snippet:
            'Lat: ${widget.sourceLocation.latitude}, Lng: ${widget.sourceLocation.longitude}',
      ),
    );

    markers[destinationMarkerId] = Marker(
      markerId: destinationMarkerId,
      position: widget.destinationLocation,
      icon: customDestinationIcon,
      infoWindow: InfoWindow(
        title: 'Destination Location',
        snippet:
            'Lat: ${widget.destinationLocation.latitude}, Lng: ${widget.destinationLocation.longitude}',
      ),
    );

    setState(() {});
  }

  void _listenToDriverLocation() {
    currentDriverLocation = socketServices.driverRealTimeLoc.value;
    socketServices.driverRealTimeLoc.listen(
      (newLocation) {
        log('New driver location: ${newLocation.latitude}, ${newLocation.longitude}');
        if (!mounted) return; // Prevent setState if widget is disposed
        setState(() {
          previousDriverLocation = currentDriverLocation;
          currentDriverLocation = newLocation;

          if (previousDriverLocation != null) {
            bearing = _calculateBearing(
                previousDriverLocation!, currentDriverLocation!);
            log('Calculated bearing: $bearing°');
          }

          _updateDriverMarker(newLocation, bearing);
          _updateCamera(newLocation);

          // Update polyline whenever there's a significant location change
          updatePolylines();
        });
      },
      onError: (error) {
        log('Error receiving driver location: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to receive driver location.')),
        );
      },
      onDone: () {
        log('Driver location stream closed.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver location stream closed.')),
        );
      },
    );
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = _toRadians(from.latitude);
    final double lon1 = _toRadians(from.longitude);
    final double lat2 = _toRadians(to.latitude);
    final double lon2 = _toRadians(to.longitude);

    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final double bearingRad = math.atan2(y, x);
    return (_toDegrees(bearingRad) + 360) % 360;
  }

  double _toRadians(double degree) => degree * math.pi / 180;
  double _toDegrees(double radian) => radian * 180 / math.pi;

  void _updateDriverMarker(LatLng newLocation, double bearing) {
    const MarkerId driverMarkerId = MarkerId('driver');

    markers[driverMarkerId] = Marker(
      markerId: driverMarkerId,
      position: newLocation,
      rotation: bearing,
      icon: customDriverIcon,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'Driver',
        snippet: 'Heading: ${bearing.toStringAsFixed(1)}°',
      ),
    );

    setState(() {});
  }

  void _updateCamera(LatLng newLocation) {
    if (previousDriverLocation == null ||
        _hasSignificantMovement(previousDriverLocation!, newLocation)) {
      socketServices.mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLocation,
            zoom: 15,
            bearing: bearing,
          ),
        ),
      );
    }
  }

  bool _hasSignificantMovement(LatLng oldLoc, LatLng newLoc) {
    return (newLoc.latitude - oldLoc.latitude).abs() > movementThreshold ||
        (newLoc.longitude - oldLoc.longitude).abs() > movementThreshold;
  }

  void _startPolylineUpdater() {
    polylineUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updatePolylines();
    });
  }

  Future<void> updatePolylines() async {
    if (currentDriverLocation == null) return;

    const String apiKey = "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc";
    if (apiKey.isEmpty) {
      log('Google API Key is missing!');
      return;
    }

    try {
      final PolylineResult sourceResult =
          await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin: PointLatLng(currentDriverLocation!.latitude,
              currentDriverLocation!.longitude),
          destination: PointLatLng(
              widget.sourceLocation.latitude, widget.sourceLocation.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (sourceResult.status == 'OK') {
        final List<LatLng> sourcePoints = sourceResult.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        const PolylineId sourcePolylineId = PolylineId('source_route');
        final Polyline sourcePolyline = Polyline(
          polylineId: sourcePolylineId,
          color: Colors.orange,
          points: sourcePoints,
          width: 4,
        );

        polylines[sourcePolylineId] = sourcePolyline;
      } else {
        log('Error fetching source route: ${sourceResult.errorMessage}');
      }

      final PolylineResult destResult =
          await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin: PointLatLng(currentDriverLocation!.latitude,
              currentDriverLocation!.longitude),
          destination: PointLatLng(widget.destinationLocation.latitude,
              widget.destinationLocation.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (destResult.status == 'OK') {
        final List<LatLng> destPoints = destResult.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        const PolylineId destPolylineId = PolylineId('destination_route');
        final Polyline destPolyline = Polyline(
          polylineId: destPolylineId,
          color: Colors.green,
          points: destPoints,
          width: 4,
        );

        polylines[destPolylineId] = destPolyline;
      } else {
        log('Error fetching destination route: ${destResult.errorMessage}');
      }

      setState(() {});
    } catch (e) {
      log('Error updating polylines: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('An error occurred while updating routes.')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentDriverLocation == null ||
        (currentDriverLocation!.latitude == 0.0 &&
            currentDriverLocation!.longitude == 0.0)) {
      return Center(
        child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
      );
    } else {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.sourceLocation,
          zoom: 15,
        ),
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (GoogleMapController controller) {
          socketServices.mapController = controller;
          if (currentDriverLocation != null) {
            controller.animateCamera(
              CameraUpdate.newLatLng(currentDriverLocation!),
            );
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
      );
    }
  }

  @override
  void dispose() {
    polylineUpdateTimer?.cancel();
    socketServices.mapController.dispose();
    super.dispose();
  }
}
