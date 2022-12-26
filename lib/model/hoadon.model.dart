import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:intl/intl.dart';

class HoaDonModel {
  String mahd = '';
  String? matv;
  late String ngayhd;
  int thanhtien = 0;
  int thanhtoan = 0;

  // HoaDonModel();

  static final HoaDonModel _instance = HoaDonModel._();

  HoaDonModel get instance => _instance;

  factory HoaDonModel() {
    return _instance;
  }

  HoaDonModel._();

  HoaDonModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    final date = DateFormat('dd/MM/yyyy');

    mahd = map['MaHD'];
    matv = map['MaTV'];
    ngayhd = date.format(DateTime.parse(map['NgayHD']));
    thanhtien = map['ThanhTien'];
    thanhtoan = map['ThanhToan'];
  }

  void fromMap({required Map<String, dynamic> map}) {
    final date = DateFormat('dd/MM/yyyy');

    mahd = map['MaHD'];
    matv = map['MaTV'];
    ngayhd = date.format(DateTime.parse(map['NgayHD']));
    thanhtien = map['ThanhTien'];
    thanhtoan = map['ThanhToan'];
  }

  Map<String, dynamic> toMap() {
    return {
      'MaTV': matv,
    };
  }

  void clear() {
    instance.mahd = '';
    instance.matv = null;
    instance.ngayhd = '';
    instance.thanhtien = 0;
    instance.thanhtoan = 0;
  }
}

class HoaDonHomeData extends DataTableSource {
  List<HoaDonModel> list = [];

  HoaDonHomeData({this.list = const []});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(list[index].mahd),
        ),
        DataCell(
          Text(list[index].matv.toString()),
        ),
        DataCell(
          Text(list[index].ngayhd),
        ),
        DataCell(
          Text(thousandDot(list[index].thanhtien)),
        ),
        DataCell(
          Text(thousandDot(list[index].thanhtoan)),
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
