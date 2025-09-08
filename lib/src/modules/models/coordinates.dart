/// Represents geographic coordinates.
class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => '($latitude, $longitude)';

  /// Converts to a map representation.
  Map<String, double> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}