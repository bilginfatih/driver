import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds? bounds;
  final List<PointLatLng>? polylinePoints;
  final String? totalDistance;
  final String? totalDuration;
  final int? totalPay;
  String? locationName;
  String? locationId;
  double? locationLatitude;
  double? locationLongitude;

  Directions({
    this.bounds,
    this.polylinePoints,
    this.totalDistance,
    this.totalDuration,
    this.totalPay,
    this.locationName,
    this.locationId,
    this.locationLatitude,
    this.locationLongitude,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    // if ((map['routes'] as List).isEmpty) return null;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    int pay = 0;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      pay = leg['distance']['value'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      totalPay: pay,
    );
  }
}
