/// English (US) location data for address generation.
class EnglishLocationData {
  static const List<String> streetSuffixes = [
    'Street', 'Avenue', 'Road', 'Boulevard', 'Drive',
    'Court', 'Place', 'Way', 'Lane', 'Trail',
    'Parkway', 'Commons', 'Circle', 'Plaza', 'Terrace',
    'Park', 'Hill', 'View', 'Creek', 'Ridge',
  ];

  static const List<String> streetNames = [
    'Main', 'Oak', 'Maple', 'Cedar', 'Elm',
    'Park', 'Washington', 'Lake', 'Hill', 'Forest',
    'First', 'Second', 'Third', 'Fourth', 'Fifth',
    'Pine', 'Market', 'Broadway', 'Sunset', 'Spring',
    'Church', 'North', 'South', 'East', 'West',
    'River', 'Mountain', 'Valley', 'Meadow', 'Grove',
  ];

  static const List<String> cityPrefixes = [
    'North', 'East', 'West', 'South', 'New',
    'Lake', 'Port', 'Mount', 'Fort', 'San',
  ];

  static const List<String> citySuffixes = [
    'ville', 'ton', 'land', 'burg', 'borough',
    'ford', 'field', 'haven', 'heights', 'beach',
    'wood', 'dale', 'park', 'view', 'port',
  ];

  static const List<String> cities = [
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
    'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose',
    'Austin', 'Jacksonville', 'San Francisco', 'Columbus', 'Indianapolis',
    'Fort Worth', 'Charlotte', 'Seattle', 'Denver', 'Washington',
    'Boston', 'El Paso', 'Nashville', 'Detroit', 'Portland',
    'Memphis', 'Oklahoma City', 'Las Vegas', 'Louisville', 'Baltimore',
    'Milwaukee', 'Albuquerque', 'Tucson', 'Fresno', 'Sacramento',
    'Kansas City', 'Mesa', 'Atlanta', 'Omaha', 'Colorado Springs',
    'Raleigh', 'Long Beach', 'Virginia Beach', 'Miami', 'Oakland',
  ];

  static const Map<String, String> states = {
    'Alabama': 'AL', 'Alaska': 'AK', 'Arizona': 'AZ', 'Arkansas': 'AR',
    'California': 'CA', 'Colorado': 'CO', 'Connecticut': 'CT', 'Delaware': 'DE',
    'Florida': 'FL', 'Georgia': 'GA', 'Hawaii': 'HI', 'Idaho': 'ID',
    'Illinois': 'IL', 'Indiana': 'IN', 'Iowa': 'IA', 'Kansas': 'KS',
    'Kentucky': 'KY', 'Louisiana': 'LA', 'Maine': 'ME', 'Maryland': 'MD',
    'Massachusetts': 'MA', 'Michigan': 'MI', 'Minnesota': 'MN', 'Mississippi': 'MS',
    'Missouri': 'MO', 'Montana': 'MT', 'Nebraska': 'NE', 'Nevada': 'NV',
    'New Hampshire': 'NH', 'New Jersey': 'NJ', 'New Mexico': 'NM', 'New York': 'NY',
    'North Carolina': 'NC', 'North Dakota': 'ND', 'Ohio': 'OH', 'Oklahoma': 'OK',
    'Oregon': 'OR', 'Pennsylvania': 'PA', 'Rhode Island': 'RI', 'South Carolina': 'SC',
    'South Dakota': 'SD', 'Tennessee': 'TN', 'Texas': 'TX', 'Utah': 'UT',
    'Vermont': 'VT', 'Virginia': 'VA', 'Washington': 'WA', 'West Virginia': 'WV',
    'Wisconsin': 'WI', 'Wyoming': 'WY',
  };

  static const List<String> countries = [
    'United States', 'Canada', 'Mexico', 'United Kingdom', 'Germany',
    'France', 'Italy', 'Spain', 'Australia', 'Japan',
    'China', 'India', 'Brazil', 'Russia', 'South Korea',
    'Netherlands', 'Belgium', 'Switzerland', 'Sweden', 'Norway',
    'Denmark', 'Finland', 'Poland', 'Austria', 'Greece',
    'Portugal', 'Ireland', 'New Zealand', 'Singapore', 'Israel',
  ];

  static const Map<String, String> countryCodes = {
    'United States': 'US', 'Canada': 'CA', 'Mexico': 'MX',
    'United Kingdom': 'GB', 'Germany': 'DE', 'France': 'FR',
    'Italy': 'IT', 'Spain': 'ES', 'Australia': 'AU',
    'Japan': 'JP', 'China': 'CN', 'India': 'IN',
    'Brazil': 'BR', 'Russia': 'RU', 'South Korea': 'KR',
  };

  static const List<String> timezones = [
    'America/New_York', 'America/Chicago', 'America/Denver', 'America/Los_Angeles',
    'America/Phoenix', 'America/Anchorage', 'Pacific/Honolulu',
    'Europe/London', 'Europe/Paris', 'Europe/Berlin', 'Europe/Rome',
    'Asia/Tokyo', 'Asia/Shanghai', 'Asia/Singapore', 'Asia/Dubai',
    'Australia/Sydney', 'Australia/Melbourne', 'Pacific/Auckland',
  ];
}