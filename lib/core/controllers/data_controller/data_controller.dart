import 'package:bin_management_system/core/app_constants/api_urls.dart';
import 'package:bin_management_system/core/network/api_services/api_service.dart';
import 'package:bin_management_system/core/utils/app_snackbar/app_snackbar.dart';
import 'package:bin_management_system/models/available_bins_model.dart';
import 'package:bin_management_system/models/booking_model.dart';
import 'package:bin_management_system/models/bookings_list_model.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  final ApiService _apiService = ApiService();
  // ignore: prefer_final_fields
  RxString _token = ''.obs;
  RxString get token => _token;

  // Loaders
  var isLoading = false.obs;
  var createBookingLoader = false.obs;
  var availableBinsLoader = false.obs;
  var bookingDetailLoader = false.obs;

  // Data
  var bookingsList = BookingsListModel().obs;
  var bookingDetailModel = Bookings().obs;
  var availableBins = AvailableBins().obs;

  Future<String?> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getSiteIdFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('siteId');
  }

  Future<void> fetchAllBookings({required String siteId}) async {
    isLoading(true);
    try {
      final token = await _getTokenFromStorage();
      if (token == null) {
        isLoading(false);
        print("No token found in storage.");
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        isLoading(false);
        print("Token has expired.");
        return;
      }

      final response = await _apiService.get(
        APIURLs.listBookings,
        queryParams: {'page': '1', 'perPage': '20', 'siteId': siteId},
      );

      bookingsList.value = BookingsListModel.fromJson(response);
      isLoading(false);

      print("Data fetched successfully: ${bookingsList.value.toJson()}");
    } catch (e) {
      isLoading(false);
      print("Error fetching data: $e");
    }
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    createBookingLoader(true);
    try {
      final token = await _getTokenFromStorage();
      if (token == null) {
        createBookingLoader(false);
        print("No token found in storage.");
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        createBookingLoader(false);
        print("Token has expired.");
        return;
      }

      final response = await _apiService.post(
        APIURLs.listBookings,
        body: bookingData,
      );


      print("Booking created successfully: $response");
      CustomSnackbar.showCustomSnackBar(
        Get.context!,
        response['message'] ?? 'Booking created successfully',
      );
      fetchAllBookings(siteId: bookingData['siteId'].toString());
      createBookingLoader(false);
      Get.back();
    } catch (e) {
      createBookingLoader(false);
      print("Error creating booking: $e");
      CustomSnackbar.showCustomSnackBar(
        Get.context!,
        e.toString(),
        error: true,
      );
    }
  }

  Future<void> fetchBookingDetails({
    required String bookingId,
    bool isLoading = false,
  }) async {
    bookingDetailLoader(isLoading);
    try {
      final token = await _getTokenFromStorage();
      if (token == null) {
        bookingDetailLoader(false);
        print("No token found in storage.");
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        bookingDetailLoader(false);
        print("Token has expired.");
        return;
      }

      final response = await _apiService.get(APIURLs.bookingDetails(bookingId));

      print("Booking details fetched successfully: $response");
      bookingDetailModel.value = Bookings.fromJson(response);
      print(
        "Booking details fetched successfully[Model]: ${bookingDetailModel.value.toJson()}",
      );
      bookingDetailLoader(false);
    } catch (e) {
      bookingDetailLoader(false);
      print("Error fetching booking details: $e");
    }
  }

  Future<void> fetchAvailableBins({required String siteId}) async {
    availableBinsLoader(true);
    try {
      final token = await _getTokenFromStorage();
      if (token == null) {
        availableBinsLoader(false);
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        availableBinsLoader(false);
        return;
      }

      final response = await _apiService.get(
        APIURLs.availableBins,
        queryParams: {'siteId': siteId, 'page': '1', 'perPage': '150'},
      );

      availableBins.value = AvailableBins.fromJson(response);
      availableBinsLoader(false);
    } catch (e) {
      availableBinsLoader(false);
    }
  }

  Future<void> completeBooking({
    required String bookingId,
    required String siteId,
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await _getTokenFromStorage();
      if (token == null) {
        print("No token found in storage.");
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        print("Token has expired.");
        return;
      }

      final response = await _apiService.put(
        APIURLs.completeBookingURL(bookingId),
        body: body ?? {},
      );

      print("Booking completed successfully: $response");
      CustomSnackbar.showCustomSnackBar(
        Get.context!,
        response['message'] ?? 'Booking completed successfully',
        success: true,
      );
      fetchAllBookings(siteId: siteId);
    } catch (e) {
      print("Error completing booking: $e");
      CustomSnackbar.showCustomSnackBar(
        Get.context!,
        e.toString(),
        error: true,
      );
    }
  }
}
