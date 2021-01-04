class UserData {
  final double proDays;
  final String avatar;
  final String username;

  UserData.fromJson(Map<String, dynamic> json)
      : proDays = json["subscription"]["days"].toDouble(),
        avatar = json["profile"]["avatar"] == "http://www.gravatar.com/avatar/"
            ? null
            : json["profile"]["avatar"],
        username = json["username"];
}
