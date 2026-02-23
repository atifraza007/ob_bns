class LoginModel {
  User? user;
  Auth? auth;

  LoginModel({this.user, this.auth});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    auth = json['auth'] != null ? Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (auth != null) {
      data['auth'] = auth!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? role;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<AssignedSites>? assignedSites;
  List<Site>? managedSites; // Fixed: Change from List<Null> to List<Site>

  User({
    this.id,
    this.email,
    this.name,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.assignedSites,
    this.managedSites,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    role = json['role'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['assignedSites'] != null) {
      assignedSites = <AssignedSites>[];
      json['assignedSites'].forEach((v) {
        assignedSites!.add(AssignedSites.fromJson(v));
      });
    }
    if (json['managedSites'] != null) {
      managedSites = <Site>[];
      json['managedSites'].forEach((v) {
        managedSites!.add(Site.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['role'] = role;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (assignedSites != null) {
      data['assignedSites'] = assignedSites!.map((v) => v.toJson()).toList();
    }
    if (managedSites != null) {
      data['managedSites'] = managedSites!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignedSites {
  int? id;
  int? userId;
  int? siteId;
  Site? site;

  AssignedSites({this.id, this.userId, this.siteId, this.site});

  AssignedSites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    siteId = json['siteId'];
    site = json['site'] != null ? Site.fromJson(json['site']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['siteId'] = siteId;
    if (site != null) {
      data['site'] = site!.toJson();
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    return data;
  }
}

class Auth {
  String? token;
  int? expiry;

  Auth({this.token, this.expiry});

  Auth.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiry = json['expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    data['expiry'] = expiry;
    return data;
  }
}
