class SpecialOfferModel {
  dynamic success;
  dynamic message;
  List<OffersList>? offersList;
  dynamic baseUrl;

  SpecialOfferModel({this.success, this.message, this.offersList, this.baseUrl});

  SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['offersList'] != null) {
      offersList = <OffersList>[];
      json['offersList'].forEach((v) {
        offersList!.add(OffersList.fromJson(v));
      });
    }
    baseUrl = json['base_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (offersList != null) {
      data['offersList'] = offersList!.map((v) => v.toJson()).toList();
    }
    data['base_url'] = baseUrl;
    return data;
  }
}

class OffersList {
  dynamic id;
  dynamic expertId;
  dynamic banner;
  dynamic type;
  dynamic startDate;
  dynamic startTime;
  dynamic endDate;
  dynamic endTime;
  dynamic description;
  dynamic categoryId;
  dynamic discountPecent;
  dynamic isFeature;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  List<Categories>? categories;

  OffersList({
    this.id,
    this.expertId,
    this.banner,
    this.type,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.description,
    this.categoryId,
    this.discountPecent,
    this.isFeature,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categories,
  });

  OffersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertId = json['expert_id'];
    banner = json['banner'];
    type = json['type'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    description = json['description'];
    categoryId = json['category_id'];
    discountPecent = json['discount_pecent'];
    isFeature = json['is_feature'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];

    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expert_id'] = expertId;
    data['banner'] = banner;
    data['type'] = type;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['discount_pecent'] = discountPecent;
    data['is_feature'] = isFeature;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;

    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Categories {
  dynamic id;
  dynamic name;
  Pivot? pivot;

  Categories({this.id, this.name, this.pivot});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  dynamic offerId;
  dynamic subCategoryId;

  Pivot({this.offerId, this.subCategoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    subCategoryId = json['sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_id'] = offerId;
    data['sub_category_id'] = subCategoryId;
    return data;
  }
}