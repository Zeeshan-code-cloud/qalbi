import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:qalbi/presentations/qibla/qibla_entity.dart';
import 'package:qalbi/presentations/qibla/qibla_repository.dart';

import '../../core/holly_makah_const/qibla_constant.dart';

class QiblaRepositoryImpl implements QiblaRepository {
  @override
  Future<QiblaEntity> getQiblaDirection() async {
    // Check location service
    final serviceEnabled =  await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Please enable your location service.');
    }

    // Check permission
    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. '
            'Please enable it from app settings.',
      );
    }

    // Get current location
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );

    // Convert coordinates to radians
    final latitude = position.latitude * math.pi / 180;
    final kaabaLatitude = QiblaConstants.kaabaLatitude * math.pi / 180;

    final longitudeDifference =
        (QiblaConstants.kaabaLongitude -
            position.longitude) *
            math.pi /
            180;

    // Calculate Qibla bearing
    final y = math.sin(longitudeDifference);

    final x = math.cos(latitude) *
        math.tan(kaabaLatitude) -
        math.sin(latitude) *
            math.cos(longitudeDifference);

    double bearing = math.atan2(y, x) * 180 / math.pi;

    bearing = (bearing + 360) % 360;

    // Calculate distance to Kaaba
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      QiblaConstants.kaabaLatitude,
      QiblaConstants.kaabaLongitude,
    );

    return QiblaEntity(
      latitude: position.latitude,
      longitude: position.longitude,
      qiblaDirection: bearing,
      distanceToKaaba: distance,
    );
  }
}