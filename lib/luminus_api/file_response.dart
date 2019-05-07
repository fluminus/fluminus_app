class FileResponse {
  String status;
  int code;
  int total;
  int offset;
  List<File> data;

  FileResponse({this.status, this.code, this.total, this.offset, this.data});

  FileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<File>();
      json['data'].forEach((v) {
        data.add(new File.fromJson(v));
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

class File {
  String id;
  String parentID;
  String resourceID;
  bool publish;
  String name;
  bool allowDownload;
  int fileSize;
  String fileFormat;
  String fileName;
  String creatorID;
  String createdDate;
  String lastUpdatedDate;
  String lastUpdatedBy;

  File(
      {this.id,
      this.parentID,
      this.resourceID,
      this.publish,
      this.name,
      this.allowDownload,
      this.fileSize,
      this.fileFormat,
      this.fileName,
      this.creatorID,
      this.createdDate,
      this.lastUpdatedDate,
      this.lastUpdatedBy});

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentID = json['parentID'];
    resourceID = json['resourceID'];
    publish = json['publish'];
    name = json['name'];
    allowDownload = json['allowDownload'];
    fileSize = json['fileSize'];
    fileFormat = json['fileFormat'];
    fileName = json['fileName'];
    creatorID = json['creatorID'];
    createdDate = json['createdDate'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentID'] = this.parentID;
    data['resourceID'] = this.resourceID;
    data['publish'] = this.publish;
    data['name'] = this.name;
    data['allowDownload'] = this.allowDownload;
    data['fileSize'] = this.fileSize;
    data['fileFormat'] = this.fileFormat;
    data['fileName'] = this.fileName;
    data['creatorID'] = this.creatorID;
    data['createdDate'] = this.createdDate;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    return data;
  }
}
