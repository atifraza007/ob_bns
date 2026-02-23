import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIURLs {
  static String baseURL = dotenv.env['API_URL']!;
  // static String baseURL = "https://bms-api-stg.oandb.co";
  static String login = '/auth/login';
  static String refreshToken = '/auth/refresh-token';
  static String forgotPassword = '/forgot-password/request-reset';

  static String listBookings = '/bookings';
  static String bookingDetails(String bookingId) => '/bookings/$bookingId';
  static String availableBins = '/bookings/available-bins';

  static String completeBookingURL(String bookingId) =>
      '/bookings/$bookingId/return';
}
