class UserData {
  final String username;
  final String password;
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final DateTime tanggalLahir;
  final String noTelepon;
  final String email;
  final String status;

  UserData(this.username, this.password, this.nama, this.jenisKelamin,
      this.alamat, this.tanggalLahir, this.noTelepon, this.email, this.status);

  UserData.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        password = json['password'] as String,
        nama = json['nama'] as String,
        jenisKelamin = json['jenisKelamin'] as String,
        alamat = json['alamat'] as String,
        tanggalLahir = json['tanggalLahir'] as DateTime,
        noTelepon = json['noTelepon'] as String,
        email = json['email'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'nama': nama,
        'jenisKelamin': jenisKelamin,
        'alamat': alamat,
        'tanggalLahir': tanggalLahir.toString(),
        'noTelepon': noTelepon,
        'email': email,
        'status': status
      };
}

class LoginCredential {
  final String username;
  final String password;

  LoginCredential(this.username, this.password);

  LoginCredential.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
