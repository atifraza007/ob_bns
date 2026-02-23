class AvailableBins {
  int? siteId;
  int? page;
  int? perPage;
  int? total;
  int? pages;
  List<Bins>? bins;

  AvailableBins({
    this.siteId,
    this.page,
    this.perPage,
    this.total,
    this.pages,
    this.bins,
  });

  AvailableBins.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    page = json['page'];
    perPage = json['perPage'];
    total = json['total'];
    pages = json['pages'];
    if (json['bins'] != null) {
      bins = <Bins>[];
      json['bins'].forEach((v) {
        bins!.add(Bins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['siteId'] = siteId;
    data['page'] = page;
    data['perPage'] = perPage;
    data['total'] = total;
    data['pages'] = pages;
    if (bins != null) {
      data['bins'] = bins!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bins {
  int? id;
  String? serialNumber;
  int? siteId;
  bool? isActive;
  String? createdAt;

  Bins({
    this.id,
    this.serialNumber,
    this.siteId,
    this.isActive,
    this.createdAt,
  });

  Bins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serialNumber'];
    siteId = json['siteId'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serialNumber'] = serialNumber;
    data['siteId'] = siteId;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    return data;
  }
}
