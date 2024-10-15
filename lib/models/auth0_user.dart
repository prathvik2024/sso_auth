class AuthOUser {
  String? sub;
  String? givenName;
  String? familyName;
  String? nickname;
  String? name;
  String? picture;
  String? updatedAt;
  String? email;
  bool? emailVerified;

  AuthOUser(
      {this.sub,
      this.givenName,
      this.familyName,
      this.nickname,
      this.name,
      this.picture,
      this.updatedAt,
      this.email,
      this.emailVerified});

  AuthOUser.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    givenName = json['given_name'];
    familyName = json['family_name'];
    nickname = json['nickname'];
    name = json['name'];
    picture = json['picture'];
    updatedAt = json['updated_at'];
    email = json['email'];
    emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub'] = sub;
    data['given_name'] = givenName;
    data['family_name'] = familyName;
    data['nickname'] = nickname;
    data['name'] = name;
    data['picture'] = picture;
    data['updated_at'] = updatedAt;
    data['email'] = email;
    data['email_verified'] = emailVerified;
    return data;
  }
}
