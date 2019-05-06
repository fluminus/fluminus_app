class AnnouncementResponse {
  String status;
  int code;
  int total;
  int offset;
  List<Announcement> data;

  AnnouncementResponse({this.status, this.code, this.total, this.offset, this.data});

  AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<Announcement>();
      json['data'].forEach((v) {
        data.add(new Announcement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['total'] = this.total;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Announcement {
  String id;
  String parentID;
  String title;
  String description;
  String displayFrom;
  String expireAfter;
  String archiveAfter;
  bool publish;
  bool sms;
  bool email;
  Access access;
  String createdDate;
  String creatorID;
  String lastUpdatedDate;
  String lastUpdatedBy;

  Announcement(
      {this.id,
      this.parentID,
      this.title,
      this.description,
      this.displayFrom,
      this.expireAfter,
      this.archiveAfter,
      this.publish,
      this.sms,
      this.email,
      this.access,
      this.createdDate,
      this.creatorID,
      this.lastUpdatedDate,
      this.lastUpdatedBy});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentID = json['parentID'];
    title = json['title'];
    description = json['description'];
    displayFrom = json['displayFrom'];
    expireAfter = json['expireAfter'];
    archiveAfter = json['archiveAfter'];
    publish = json['publish'];
    sms = json['sms'];
    email = json['email'];
    access =
        json['access'] != null ? new Access.fromJson(json['access']) : null;
    createdDate = json['createdDate'];
    creatorID = json['creatorID'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentID'] = this.parentID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['displayFrom'] = this.displayFrom;
    data['expireAfter'] = this.expireAfter;
    data['archiveAfter'] = this.archiveAfter;
    data['publish'] = this.publish;
    data['sms'] = this.sms;
    data['email'] = this.email;
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    data['createdDate'] = this.createdDate;
    data['creatorID'] = this.creatorID;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    return data;
  }
}

class Access {
  bool accessFull;
  bool accessRead;
  bool accessCreate;
  bool accessUpdate;
  bool accessDelete;
  bool accessSettingsRead;
  bool accessSettingsUpdate;

  Access(
      {this.accessFull,
      this.accessRead,
      this.accessCreate,
      this.accessUpdate,
      this.accessDelete,
      this.accessSettingsRead,
      this.accessSettingsUpdate});

  Access.fromJson(Map<String, dynamic> json) {
    accessFull = json['access_Full'];
    accessRead = json['access_Read'];
    accessCreate = json['access_Create'];
    accessUpdate = json['access_Update'];
    accessDelete = json['access_Delete'];
    accessSettingsRead = json['access_Settings_Read'];
    accessSettingsUpdate = json['access_Settings_Update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_Full'] = this.accessFull;
    data['access_Read'] = this.accessRead;
    data['access_Create'] = this.accessCreate;
    data['access_Update'] = this.accessUpdate;
    data['access_Delete'] = this.accessDelete;
    data['access_Settings_Read'] = this.accessSettingsRead;
    data['access_Settings_Update'] = this.accessSettingsUpdate;
    return data;
  }
}