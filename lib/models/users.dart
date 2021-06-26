class Users {
  String uid;
  String name;
  String email;
  String username;
  String status;
  String profession;
  String bio;
  String phoneNumber;
  int state;
  String profilePhoto;
  int followers;
  int following;
  bool isLive;

  Users({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.profession,
    this.bio,
    this.phoneNumber,
    this.state,
    this.profilePhoto,
    this.followers,
    this.following,
    this.isLive = false,
  });

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["profession"] = user.profession;
    data["bio"] = user.bio;
    data["phone_number"] = user.phoneNumber;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["is_live"] = user.isLive;
    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.profession = mapData['profession'];
    this.bio = mapData['bio'];
    this.phoneNumber = mapData['phone_number'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.isLive = mapData['is_live'];
  }

  Map follow(Users users) {
    var data = Map<String, dynamic>();
    data["uid"] = users.uid;
    return data;
  }

  Users.getFollow(Map<String, dynamic> map) {
    this.uid = map['uid'];
  }

  Users.fromFollowMap(Map<String, dynamic> mapData) {
    this.followers = mapData['followers'];
    this.following = mapData['following'];
  }
}
