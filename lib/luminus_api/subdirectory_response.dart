class SubdirectoryResponse {
  String status;
  int code;
  int total;
  int offset;
  List<Directory> data;

  SubdirectoryResponse({this.status, this.code, this.total, this.offset, this.data});

  SubdirectoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<Directory>();
      json['data'].forEach((v) {
        data.add(new Directory.fromJson(v));
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

class Directory {
  Access access;
  String id;
  String createdDate;
  String creatorID;
  String lastUpdatedDate;
  String lastUpdatedBy;
  String name;
  String startDate;
  String endDate;
  bool publish;
  String parentID;
  String rootID;
  String sortFilesBy;
  bool allowUpload;
  String uploadDisplayOption;
  bool viewAll;
  int folderScore;
  bool allowComments;
  bool isTurnitinFolder;

  Directory(
      {this.access,
      this.id,
      this.createdDate,
      this.creatorID,
      this.lastUpdatedDate,
      this.lastUpdatedBy,
      this.name,
      this.startDate,
      this.endDate,
      this.publish,
      this.parentID,
      this.rootID,
      this.sortFilesBy,
      this.allowUpload,
      this.uploadDisplayOption,
      this.viewAll,
      this.folderScore,
      this.allowComments,
      this.isTurnitinFolder});

  Directory.fromJson(Map<String, dynamic> json) {
    access =
        json['access'] != null ? new Access.fromJson(json['access']) : null;
    id = json['id'];
    createdDate = json['createdDate'];
    creatorID = json['creatorID'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    publish = json['publish'];
    parentID = json['parentID'];
    rootID = json['rootID'];
    sortFilesBy = json['sortFilesBy'];
    allowUpload = json['allowUpload'];
    uploadDisplayOption = json['uploadDisplayOption'];
    viewAll = json['viewAll'];
    folderScore = json['folderScore'];
    allowComments = json['allowComments'];
    isTurnitinFolder = json['isTurnitinFolder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    data['id'] = this.id;
    data['createdDate'] = this.createdDate;
    data['creatorID'] = this.creatorID;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['publish'] = this.publish;
    data['parentID'] = this.parentID;
    data['rootID'] = this.rootID;
    data['sortFilesBy'] = this.sortFilesBy;
    data['allowUpload'] = this.allowUpload;
    data['uploadDisplayOption'] = this.uploadDisplayOption;
    data['viewAll'] = this.viewAll;
    data['folderScore'] = this.folderScore;
    data['allowComments'] = this.allowComments;
    data['isTurnitinFolder'] = this.isTurnitinFolder;
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
