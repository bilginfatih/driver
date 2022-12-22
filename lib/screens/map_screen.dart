import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/package_info_helper.dart';
import '../models/directions_model.dart';
import '../pages/login_page.dart';
import '../repository/direction_repository.dart';
import 'select_photo_options_screen.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.66896, 29.898653),
    zoom: 11.5,
  );
  void getEmail() {
    if (FirebaseAuth.instance.currentUser != null) {
      userEmail = FirebaseAuth.instance.currentUser!.email!;
      setState(() {
        isEmailGet = true;
      });
    }
  }

  bool isEmailGet = false;
  late String userEmail;
  Marker? basla;
  Marker? bitis;
  Directions? _info;
  Location currentlocation = Location();
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      File? img = File(image.path);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  late GoogleMapController _googleMapController;
  Set<Polyline> polylines = {};

  void _onMapCreated(GoogleMapController _cntlr) {
    _googleMapController = _cntlr;
    currentlocation.onLocationChanged.listen((l) {});
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_info != null) {
      double pay = _info!.totalPay! / 10;
    }
    Set<Marker> markers = {};
    if (basla != null) {
      markers.add(basla!);
    }
    if (bitis != null) {
      markers.add(bitis!);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: false,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rota Planlama",
              ),
              Row(
                children: [
                  Text(
                    "Version: ${PackageInfoHelper.info?.version ?? "1.0.0"}",
                    style: TextStyle(fontSize: 6),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (basla != null && bitis != null)
            TextButton(
                onPressed: () {
                  polylines.clear();
                  bitis = null;
                  basla = null;
                  _info = null;
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text("Sıfırla")),
          if (basla != null)
            TextButton(
              onPressed: () {
                _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: basla!.position, zoom: 14.5, tilt: 50.0),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("Başlangıç"),
            ),
          if (bitis != null)
            TextButton(
                onPressed: () {
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: bitis!.position, zoom: 14.5, tilt: 50),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text("Varış"))
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 3 / 4,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (() {
                  _showSelectPhotoOptions(context);
                }),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Center(
                      child: _image == null
                          ? const Text(
                              "Fotoğraf Seç",
                              textAlign: TextAlign.center,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(_image!),
                              radius: 200,
                            ),
                    ),
                  ),
                ),
              ),
              accountEmail: isEmailGet ? Text(userEmail) : const CircularProgressIndicator(),
              accountName: const Text(
                "Fatih Bilgin",
                style: TextStyle(fontSize: 24.0),
              ),
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(fontSize: 24.0),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              currentlocation.onLocationChanged.listen((l) {});
            },
            onTap: (argument) {
              print("tiklandi");
            },
            onLongPress: _addMarker,
            polylines: polylines.isEmpty ? {} : polylines,
            markers: markers,
          ),
          if (_info != null)
            Positioned(
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6.0),
                  ],
                ),
                child: Text(
                  '${_info?.totalDistance}, ${_info!.totalDuration}\n${(_info!.totalPay! / 100 + 9).toStringAsFixed(2)} TL',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (basla == null || (basla != null && bitis != null)) {
      setState(
        () {
          basla = Marker(
            markerId: const MarkerId("basla"),
            infoWindow: const InfoWindow(title: 'Basla'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: pos,
          );
          bitis = null;
          polylines.clear();
          _info = null;
        },
      );
    } else {
      setState(
        () {
          bitis = Marker(
            markerId: const MarkerId("bitis"),
            infoWindow: const InfoWindow(title: 'Bitis'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
            position: pos,
          );
          getPolyPoints().then((value) {
            return polylines = value;
          });
        },
      );
      final directions = await DirectionsRepository().getDirections(origin: basla!.position, destination: bitis!.position);
      setState(() {
        _info = directions!;
      });
    }
  }

  Future<Set<Polyline>> getPolyPoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key, PointLatLng(basla!.position.latitude, basla!.position.longitude), PointLatLng(bitis!.position.latitude, bitis!.position.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
    return {
      Polyline(
        color: Colors.purple,
        onTap: () {
          print("object");
        },
        consumeTapEvents: true,
        startCap: Cap.roundCap,
        width: 4,
        polylineId: PolylineId('value'),
        points: polylineCoordinates,
      )
    };
  }
}
