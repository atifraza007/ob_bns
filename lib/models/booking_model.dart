class Bookings {
  int? id;
  String? bookingRef;
  String? status;
  int? siteId;
  int? subcontractorId;
  String? startDate;
  String? expectedEndDate;
  int? bookedById;
  String? createdAt;
  String? updatedAt;
  Site? site;
  Subcontractor? subcontractor;
  BookedBy? bookedBy;
  List<Items>? items;

  Bookings({
    this.id,
    this.bookingRef,
    this.status,
    this.siteId,
    this.subcontractorId,
    this.startDate,
    this.expectedEndDate,
    this.bookedById,
    this.createdAt,
    this.updatedAt,
    this.site,
    this.subcontractor,
    this.bookedBy,
    this.items,
  });

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingRef = json['bookingRef'];
    status = json['status'];
    siteId = json['siteId'];
    subcontractorId = json['subcontractorId'];
    startDate = json['startDate'];
    expectedEndDate = json['expectedEndDate'];
    bookedById = json['bookedById'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    site = json['site'] != null ? Site.fromJson(json['site']) : null;
    subcontractor = json['subcontractor'] != null
        ? Subcontractor.fromJson(json['subcontractor'])
        : null;
    bookedBy = json['bookedBy'] != null
        ? BookedBy.fromJson(json['bookedBy'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingRef'] = bookingRef;
    data['status'] = status;
    data['siteId'] = siteId;
    data['subcontractorId'] = subcontractorId;
    data['startDate'] = startDate;
    data['expectedEndDate'] = expectedEndDate;
    data['bookedById'] = bookedById;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (site != null) {
      data['site'] = site!.toJson();
    }
    if (subcontractor != null) {
      data['subcontractor'] = subcontractor!.toJson();
    }
    if (bookedBy != null) {
      data['bookedBy'] = bookedBy!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Site {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? mobile;
  String? postalCode;
  String? status;
  int? siteManagerId;
  String? createdAt;
  String? updatedAt;
  SiteManager? siteManager;

  Site({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.mobile,
    this.postalCode,
    this.status,
    this.siteManagerId,
    this.createdAt,
    this.updatedAt,
    this.siteManager,
  });

  Site.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    mobile = json['mobile'];
    postalCode = json['postal_code'];
    status = json['status'];
    siteManagerId = json['siteManagerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    siteManager = json['siteManager'] != null
        ? SiteManager.fromJson(json['siteManager'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['mobile'] = mobile;
    data['postal_code'] = postalCode;
    data['status'] = status;
    data['siteManagerId'] = siteManagerId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (siteManager != null) {
      data['siteManager'] = siteManager!.toJson();
    }
    return data;
  }
}

class SiteManager {
  int? id;
  String? email;
  String? name;

  SiteManager({this.id, this.email, this.name});

  SiteManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}

class Subcontractor {
  int? id;
  String? companyName;
  String? contactName;
  String? contactPhone;
  int? siteId;
  String? createdAt;
  String? updatedAt;
  List<Workers>? workers;

  Subcontractor({
    this.id,
    this.companyName,
    this.contactName,
    this.contactPhone,
    this.siteId,
    this.createdAt,
    this.updatedAt,
    this.workers,
  });

  Subcontractor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    siteId = json['siteId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['workers'] != null) {
      workers = <Workers>[];
      json['workers'].forEach((v) {
        workers!.add(Workers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['contactName'] = contactName;
    data['contactPhone'] = contactPhone;
    data['siteId'] = siteId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (workers != null) {
      data['workers'] = workers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Workers {
  int? id;
  String? name;
  String? email;
  bool? isActive;
  int? subcontractorId;
  String? createdAt;

  Workers({
    this.id,
    this.name,
    this.email,
    this.isActive,
    this.subcontractorId,
    this.createdAt,
  });

  Workers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isActive = json['isActive'];
    subcontractorId = json['subcontractorId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['isActive'] = isActive;
    data['subcontractorId'] = subcontractorId;
    data['createdAt'] = createdAt;
    return data;
  }
}

class BookedBy {
  int? id;
  String? email;
  String? name;
  String? role;

  BookedBy({this.id, this.email, this.name, this.role});

  BookedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['role'] = role;
    return data;
  }
}

class Items {
  int? id;
  int? bookingId;
  int? binId;
  String? startDate;
  String? expectedEndDate;
  String? assignedAt;
  String? returnedAt;
  String? createdAt;
  Bin? bin;

  Items({
    this.id,
    this.bookingId,
    this.binId,
    this.startDate,
    this.expectedEndDate,
    this.assignedAt,
    this.returnedAt,
    this.createdAt,
    this.bin,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    binId = json['binId'];
    startDate = json['startDate'];
    expectedEndDate = json['expectedEndDate'];
    assignedAt = json['assignedAt'];
    returnedAt = json['returnedAt']; // Adjusted
    createdAt = json['createdAt'];
    bin = json['bin'] != null ? Bin.fromJson(json['bin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingId'] = bookingId;
    data['binId'] = binId;
    data['startDate'] = startDate;
    data['expectedEndDate'] = expectedEndDate;
    data['assignedAt'] = assignedAt;
    data['returnedAt'] = returnedAt; // Adjusted
    data['createdAt'] = createdAt;
    if (bin != null) {
      data['bin'] = bin!.toJson();
    }
    return data;
  }
}

class Bin {
  int? id;
  String? serialNumber;
  int? siteId;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Bin({
    this.id,
    this.serialNumber,
    this.siteId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Bin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serialNumber'];
    siteId = json['siteId'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serialNumber'] = serialNumber;
    data['siteId'] = siteId;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
