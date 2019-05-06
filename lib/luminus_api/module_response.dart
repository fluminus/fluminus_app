class ModuleResponse {
  String status;
  int code;
  int total;
  int offset;
  List<Module> data;

  ModuleResponse({this.status, this.code, this.total, this.offset, this.data});

  ModuleResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<Module>();
      json['data'].forEach((v) {
        data.add(new Module.fromJson(v));
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

class Module {
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
  String resourceID;
  Access access;
  String courseName;
  String facultyCode;
  String departmentCode;
  String term;
  String acadCareer;
  bool courseSearchable;
  String allowAnonFeedback;
  bool displayLibGuide;
  String copyFromID;
  bool l3;
  bool enableLearningFlow;
  bool usedNusCalendar;
  bool isCorporateCourse;

  Module(
      {this.id,
      this.createdDate,
      this.creatorID,
      this.lastUpdatedDate,
      this.lastUpdatedBy,
      this.name,
      this.startDate,
      this.endDate,
      this.publish,
      this.parentID,
      this.resourceID,
      this.access,
      this.courseName,
      this.facultyCode,
      this.departmentCode,
      this.term,
      this.acadCareer,
      this.courseSearchable,
      this.allowAnonFeedback,
      this.displayLibGuide,
      this.copyFromID,
      this.l3,
      this.enableLearningFlow,
      this.usedNusCalendar,
      this.isCorporateCourse});

  Module.fromJson(Map<String, dynamic> json) {
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
    resourceID = json['resourceID'];
    access =
        json['access'] != null ? new Access.fromJson(json['access']) : null;
    courseName = json['courseName'];
    facultyCode = json['facultyCode'];
    departmentCode = json['departmentCode'];
    term = json['term'];
    acadCareer = json['acadCareer'];
    courseSearchable = json['courseSearchable'];
    allowAnonFeedback = json['allowAnonFeedback'];
    displayLibGuide = json['displayLibGuide'];
    copyFromID = json['copyFromID'];
    l3 = json['l3'];
    enableLearningFlow = json['enableLearningFlow'];
    usedNusCalendar = json['usedNusCalendar'];
    isCorporateCourse = json['isCorporateCourse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['resourceID'] = this.resourceID;
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    data['courseName'] = this.courseName;
    data['facultyCode'] = this.facultyCode;
    data['departmentCode'] = this.departmentCode;
    data['term'] = this.term;
    data['acadCareer'] = this.acadCareer;
    data['courseSearchable'] = this.courseSearchable;
    data['allowAnonFeedback'] = this.allowAnonFeedback;
    data['displayLibGuide'] = this.displayLibGuide;
    data['copyFromID'] = this.copyFromID;
    data['l3'] = this.l3;
    data['enableLearningFlow'] = this.enableLearningFlow;
    data['usedNusCalendar'] = this.usedNusCalendar;
    data['isCorporateCourse'] = this.isCorporateCourse;
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
