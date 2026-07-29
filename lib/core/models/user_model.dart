class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nip;
  final String? nisn;
  final String? phone;
  final String? ttl;
  final String? gender;
  final String? subject;
  final String? school;
  final String? address;
  final String? photo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nip,
    this.nisn,
    this.phone,
    this.ttl,
    this.gender,
    this.subject,
    this.school,
    this.address,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      nip: json["nip"],
      nisn: json["nisn"],
      phone: json["phone"],
      ttl: json["ttl"],
      gender: json["gender"] ?? json["jenis_kelamin"],
      subject: json["subject"] ?? json["mata_pelajaran"],
      school: json["school"] ?? json["sekolah_asal"],
      address: json["address"] ?? json["alamat"],
      photo: json["photo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "nip": nip,
        "nisn": nisn,
        "phone": phone,
        "ttl": ttl,
        "gender": gender,
        "subject": subject,
        "school": school,
        "address": address,
        "photo": photo,
      };
}
