class UserDetails {
  String? displayName;
  String? email;
  String? photoUrl;

  UserDetails({this.displayName, this.email, this.photoUrl});
  UserDetails.fromJson(Map<String, dynamic> json) {
    displayName = json["displayName"];
    photoUrl = json["photoUrl"];
    email = json["email"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["displayName"] = displayName;
    data["photoUrl"] = photoUrl;
    data["email"] = email;
    return data;
  }
}
