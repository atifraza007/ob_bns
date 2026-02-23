import 'package:bin_management_system/models/booking_model.dart';

class BookingsListModel {
  int? page;
  int? perPage;
  int? total;
  int? pages;
  List<Bookings>? bookings;

  BookingsListModel({
    this.page,
    this.perPage,
    this.total,
    this.pages,
    this.bookings,
  });

  BookingsListModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    total = json['total'];
    pages = json['pages'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['perPage'] = perPage;
    data['total'] = total;
    data['pages'] = pages;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
