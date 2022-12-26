class TheThanhVienModel {
  late String matv;
  String? makh;
  int? maltv;
  late String taikhoan;
  late String matkhau;
  late int diemtich;
  late int tyletich;
  late int tyledoi;

  TheThanhVienModel();

  TheThanhVienModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    matv = map['MaTV'];
    makh = map['MaKH'];
    maltv = map['MaTP'];
    taikhoan = map['TaiKhoan'];
    diemtich = map['DiemTich'];
    tyletich = map['TyLeTich'];
    tyledoi = map['TyLeDoi'];
  }

  Map<String, dynamic> toMap() {
    return {
      'MaTV': matv,
      'MaKH': makh,
      'MaLTV': maltv,
      'TaiKhoan': taikhoan,
      'MatKhau': matkhau,
      'DiemTich': diemtich,
      'TyLeTich': tyletich,
      'TyLeDoi': tyledoi,
    };
  }
}

class TheThanhVienTraCuuModel {
  late String matv;
  late String hoten;
  late String loaithe;
  late int giamgia;
  late int tichdiem;
  late int diemtich;
  late int tyletich;
  late int tyledoi;

  TheThanhVienTraCuuModel();

  TheThanhVienTraCuuModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    hoten = map['HoTen'];
    loaithe = map['LoaiThe'];
    giamgia = map['GiamGia'];
    tichdiem = map['TichDiem'];
    diemtich = map['DiemTich'];
    tyletich = map['TyLeTich'];
    tyledoi = map['TyLeDoi'];
  }
}

class LoaiThanhVienModel {
  late int maltv;
  late String ten;

  LoaiThanhVienModel();

  LoaiThanhVienModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    maltv = map['MaLTV'];
    ten = map['Ten'];
  }
}
