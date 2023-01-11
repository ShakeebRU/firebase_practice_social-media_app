class UserModel {
  UserModel({
    required this.name,
    required this.password,
    required this.email,
    required this.address,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.profileImage,
  });
  late final String name;
  late final String password;
  late final String email;
  late final String address;
  late final String phone;
  late final String dob;
  late final String gender;
  late final String profileImage;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    profileImage = json['profileimage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['password'] = password;
    _data['email'] = email;
    _data['address'] = address;
    _data['phone'] = phone;
    _data['dob'] = dob;
    _data['gender'] = gender;
    _data['profileimage'] = profileImage;
    return _data;
  }
}
