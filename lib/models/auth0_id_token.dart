class AuthOIdToken {
  String? givenName;
  String? familyName;
  String? nickname;
  String? name;
  String? picture;
  String? updatedAt;
  String? email;
  bool? emailVerified;
  String? iss;
  String? aud;
  int? iat;
  int? exp;
  String? sub;
  int? authTime;
  String? sid;
  String? nonce;

  AuthOIdToken(
      {this.givenName,
      this.familyName,
      this.nickname,
      this.name,
      this.picture,
      this.updatedAt,
      this.email,
      this.emailVerified,
      this.iss,
      this.aud,
      this.iat,
      this.exp,
      this.sub,
      this.authTime,
      this.sid,
      this.nonce});

  AuthOIdToken.fromJson(Map<String, dynamic> json) {
    givenName = json['given_name'];
    familyName = json['family_name'];
    nickname = json['nickname'];
    name = json['name'];
    picture = json['picture'];
    updatedAt = json['updated_at'];
    email = json['email'];
    emailVerified = json['email_verified'];
    iss = json['iss'];
    aud = json['aud'];
    iat = json['iat'];
    exp = json['exp'];
    sub = json['sub'];
    authTime = json['auth_time'];
    sid = json['sid'];
    nonce = json['nonce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['given_name'] = givenName;
    data['family_name'] = familyName;
    data['nickname'] = nickname;
    data['name'] = name;
    data['picture'] = picture;
    data['updated_at'] = updatedAt;
    data['email'] = email;
    data['email_verified'] = emailVerified;
    data['iss'] = iss;
    data['aud'] = aud;
    data['iat'] = iat;
    data['exp'] = exp;
    data['sub'] = sub;
    data['auth_time'] = authTime;
    data['sid'] = sid;
    data['nonce'] = nonce;
    return data;
  }
}
