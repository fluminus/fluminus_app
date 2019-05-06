class Profile {
  String id;
  String userID;
  String expireDate;
  String userNameOriginal;
  String userMatricNo;
  String nickName;
  String officialEmail;
  String email;
  bool displayPhoto;

  Profile(
      {this.id,
      this.userID,
      this.expireDate,
      this.userNameOriginal,
      this.userMatricNo,
      this.nickName,
      this.officialEmail,
      this.email,
      this.displayPhoto});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    expireDate = json['expireDate'];
    userNameOriginal = json['userNameOriginal'];
    userMatricNo = json['userMatricNo'];
    nickName = json['nickName'];
    officialEmail = json['officialEmail'];
    email = json['email'];
    displayPhoto = json['displayPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userID'] = this.userID;
    data['expireDate'] = this.expireDate;
    data['userNameOriginal'] = this.userNameOriginal;
    data['userMatricNo'] = this.userMatricNo;
    data['nickName'] = this.nickName;
    data['officialEmail'] = this.officialEmail;
    data['email'] = this.email;
    data['displayPhoto'] = this.displayPhoto;
    return data;
  }
}
