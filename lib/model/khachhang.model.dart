import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class KhachHangModel {
  late String makh;
  int? maqt;
  int? matp;
  int? maqh;
  int? mapx;
  late String hoten;
  late String ngaysinh;
  String? gioitinh;
  late String cccd;
  String? sonha;
  String? email;
  String? dienthoai;

  KhachHangModel({
    this.maqt,
    this.matp,
    this.maqh,
    this.mapx,
    required this.hoten,
    required this.ngaysinh,
    this.gioitinh,
    required this.cccd,
    this.sonha,
    this.email,
    this.dienthoai,
  });

  KhachHangModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    final date = DateFormat('dd/MM/yyyy');

    makh = map['MaKH'];
    maqt = map['MaQT'];
    matp = map['MaTP'];
    maqh = map['MaQH'];
    mapx = map['MaPX'];
    hoten = map['HoTen'];
    ngaysinh = date.format(DateTime.parse(map['NgaySinh']));
    gioitinh = map['GioiTinh'];
    cccd = map['CCCD'];
    sonha = map['SoNha'];
    email = map['Email'];
    dienthoai = map['DienThoai'];
  }

  Map<String, dynamic> toMap() {
    return {
      'MaQT': maqt,
      'MaTP': matp,
      'MaQH': maqh,
      'MaPX': mapx,
      'HoTen': hoten,
      'NgaySinh': ngaysinh,
      'GioiTinh': gioitinh,
      'CCCD': cccd,
      'SoNha': sonha,
      'Email': email,
      'DienThoai': dienthoai,
    };
  }
}

class KhachHangTraCuuModel {
  late String makh;
  String? matv;
  late String quoctich;
  String? sonha;
  late String noisong;
  late String hoten;
  late String ngaysinh;
  late String gioitinh;
  String? email;
  String? loaithe;
  String? taikhoan;
  String? matkhau;
  int? diemtich;
  int? tyletich;
  int? tyledoi;

  KhachHangTraCuuModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    final date = DateFormat('dd/MM/yyyy');

    makh = map["MaKH"];
    matv = map["MaTV"];
    quoctich = map["QuocTich"];
    sonha = map["SoNha"];
    noisong = map["NoiSong"];
    hoten = map["HoTen"];
    ngaysinh = date.format(DateTime.parse(map['NgaySinh']));
    gioitinh = map["GioiTinh"];
    email = map["Email"];
    loaithe = map["LoaiThe"];
    taikhoan = map["TaiKhoan"];
    matkhau = map["MatKhau"];
    diemtich = map["DiemTich"];
    tyletich = map["TyLeTich"];
    tyledoi = map["TyLeDoi"];
  }
}

class KhachHangHomeData extends DataTableSource {
  late BuildContext context;
  late Future<void> Function() callback;
  List<KhachHangTraCuuModel> list = [];

  KhachHangHomeData({this.list = const []});

  void onTap({required KhachHangTraCuuModel index}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialogMin(
        instance: index,
        callback: callback,
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            children: [
              Text(list[index].makh),
              Text("${list[index].matv}"),
            ],
          ),
          onTap: () => onTap(index: list[index]),
        ),
        DataCell(
          Text(list[index].hoten),
          onTap: () => onTap(index: list[index]),
        ),
        DataCell(
          Text(list[index].loaithe.toString()),
          onTap: () => onTap(index: list[index]),
        ),
        DataCell(
          Text(list[index].ngaysinh),
          onTap: () => onTap(index: list[index]),
        ),
        DataCell(
          Text(list[index].gioitinh),
          onTap: () => onTap(index: list[index]),
        ),
        DataCell(
          Text(list[index].quoctich),
          onTap: () => onTap(index: list[index]),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}

enum ThongTinType { quocTich, tinhThanhPho, quanHuyen, phuongXa }

abstract class KhachHangThongTin {
  late int ma;
  late int maPhu;
  late String ten;

  factory KhachHangThongTin(ThongTinType type, Map<String, dynamic> map) {
    switch (type) {
      case ThongTinType.quocTich:
        return QuocTichModel.fromMap(map: map);
      case ThongTinType.tinhThanhPho:
        return TinhThanhPhoModel.fromMap(map: map);
      case ThongTinType.quanHuyen:
        return QuanHuyenModel.fromMap(map: map);
      case ThongTinType.phuongXa:
        return PhuongXaModel.fromMap(map: map);
    }
  }
}

class ThongTinModel implements KhachHangThongTin {
  @override
  late int ma;

  @override
  late int maPhu;

  @override
  late String ten;

  final List<KhachHangThongTin> datas = [];

  void addData(KhachHangThongTin data) => datas.add(data);
}

class QuocTichModel implements KhachHangThongTin {
  @override
  late int ma;

  @override
  late int maPhu;

  @override
  late String ten;

  QuocTichModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    ma = map['MaQT'];
    ten = map['Ten'];
  }
}

class TinhThanhPhoModel implements KhachHangThongTin {
  @override
  late int ma;

  @override
  late int maPhu;

  @override
  late String ten;

  TinhThanhPhoModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    ma = map['MaTP'];
    ten = map['Ten'];
  }
}

class QuanHuyenModel implements KhachHangThongTin {
  @override
  late int ma;

  @override
  late int maPhu;

  @override
  late String ten;

  QuanHuyenModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    ma = map['MaQH'];
    maPhu = map['MaTP'];
    ten = map['Ten'];
  }
}

class PhuongXaModel implements KhachHangThongTin {
  @override
  late int ma;

  @override
  late int maPhu;

  @override
  late String ten;

  PhuongXaModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    ma = map['MaPX'];
    maPhu = map['MaQH'];
    ten = map['Ten'];
  }
}

class AlertDialogMin extends StatefulWidget {
  final KhachHangTraCuuModel instance;
  final Future<void> Function() callback;

  const AlertDialogMin({
    Key? key,
    required this.instance,
    required this.callback,
  }) : super(key: key);

  @override
  State<AlertDialogMin> createState() => _AlertDialogMinState();
}

class _AlertDialogMinState extends State<AlertDialogMin> {
  final TextStyle baseHeadStyle = const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );

  final TextStyle baseTextStyle = const TextStyle(fontSize: 20.0);

  Widget baseCell({required Widget widget}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: widget,
      ),
    );
  }

  Future<void> xoaDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/khachHang"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaKH': widget.instance.makh,
      }),
    );

    if (response.statusCode == 200) {
      widget.callback();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        Flushbar(
          message: 'Xóa dữ liệu thất bại',
          messageSize: 20.0,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade900,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final KhachHangTraCuuModel instance = widget.instance;

    return SizedBox(
      width: double.infinity,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(10.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Table(
                defaultColumnWidth: const FixedColumnWidth(300.0),
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          "Họ và tên",
                          style: baseHeadStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          "Số nhà",
                          style: baseHeadStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          instance.hoten,
                          style: baseTextStyle,
                        ),
                      ),
                      baseCell(
                          widget: Text(
                        instance.sonha.toString(),
                        style: baseTextStyle,
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          "Email",
                          style: baseHeadStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          "Điểm tích",
                          style: baseHeadStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          instance.email.toString(),
                          style: baseTextStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          instance.diemtich == null
                              ? "null"
                              : thousandDot(instance.diemtich as int),
                          style: baseTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      baseCell(
                          widget: Text(
                        "Tỷ lệ tích",
                        style: baseHeadStyle,
                      )),
                      baseCell(
                        widget: Text(
                          "Tỷ lệ đổi",
                          style: baseHeadStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          instance.tyletich == null
                              ? "null"
                              : thousandDot(instance.tyletich as int),
                          style: baseTextStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          instance.tyledoi == null
                              ? "null"
                              : thousandDot(instance.tyledoi as int),
                          style: baseTextStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          "Tài khoản",
                          style: baseHeadStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          "Mật khẩu",
                          style: baseHeadStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          instance.taikhoan.toString(),
                          style: baseTextStyle,
                        ),
                      ),
                      baseCell(
                        widget: Text(
                          instance.matkhau.toString(),
                          style: baseTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          "Nơi sống",
                          style: baseHeadStyle,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      baseCell(
                        widget: Text(
                          instance.noisong,
                          style: baseTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: (() async => await xoaDuLieu()),
                  child: Text(
                    "Xóa khách hàng",
                    style: baseTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
