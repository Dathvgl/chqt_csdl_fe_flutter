import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:intl/intl.dart';

class QuyDoiModel {
  late String maqd;
  late String matv;
  late int diemtich;
  late int thanhtien;
  late String ngaydoi;

  QuyDoiModel({
    required this.matv,
    required this.diemtich,
  });

  QuyDoiModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    final date = DateFormat('dd/MM/yyyy');

    maqd = map['MaQD'];
    matv = map['MaTV'];
    diemtich = map['DiemTich'];
    thanhtien = map['ThanhTien'];
    ngaydoi = date.format(DateTime.parse(map['NgayDoi']));
  }

  Map<String, dynamic> toMap() {
    return {
      'MaTV': matv,
      'DiemTich': diemtich,
    };
  }
}

class QuyDoiHomeData extends DataTableSource {
  List<QuyDoiModel> list = [];

  QuyDoiHomeData({this.list = const []});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(list[index].maqd),
        ),
        DataCell(
          Text(list[index].matv.toString()),
        ),
        DataCell(
          Text(list[index].diemtich.toString()),
        ),
        DataCell(
          Text(thousandDot(list[index].thanhtien)),
        ),
        DataCell(
          Text(list[index].ngaydoi),
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
