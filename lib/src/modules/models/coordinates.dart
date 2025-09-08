/// Represents geographic coordinates.
class Coordinates {
  /// The latitude coordinate in degrees.
  final double latitude;

  /// The longitude coordinate in degrees.
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
