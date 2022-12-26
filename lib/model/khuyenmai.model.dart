import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class KhuyenMaiModel {
  late String ten;
  late int sotien;
  String? ngaybatdau;
  String? ngayhethan;

  KhuyenMaiModel({
    required this.ten,
    required this.sotien,
  });

  Map<String, dynamic> toMap() {
    return {
      'Ten': ten,
      'SoTien': sotien,
      'NgayBatDau': ngaybatdau,
      'NgayHetHan': ngayhethan,
    };
  }
}

class KhuyenMaiTraCuuModel {
  late String makm;
  late String ten;
  late int sotien;
  String? ngaybatdau;
  String? ngayhethan;
  late int conlai;
  late int soluong;

  KhuyenMaiTraCuuModel.fromMap({
    required Map<String, dynamic> map,
  }) {
    final date = DateFormat('dd/MM/yyyy');

    makm = map["MaKM"];
    ten = map["Ten"];
    sotien = map["SoTien"];
    ngaybatdau = map["NgayBatDau"] == null
        ? null
        : date.format(DateTime.parse(map["NgayBatDau"]));
    ngayhethan = map["NgayHetHan"] == null
        ? null
        : date.format(DateTime.parse(map["NgayHetHan"]));
    conlai = map["ConLai"];
    soluong = map["SoLuong"];
  }
}

class KhuyenMaiHomeData extends DataTableSource {
  late BuildContext context;
  late Future<void> Function() callback;
  List<KhuyenMaiTraCuuModel> list = [];

  KhuyenMaiHomeData({this.list = const []});

  void onTap({required String index}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialogMin(
        id: index,
        callback: callback,
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(list[index].makm.toString()),
          onTap: () => onTap(index: list[index].makm),
        ),
        DataCell(
          Text(list[index].ten),
          onTap: () => onTap(index: list[index].makm),
        ),
        DataCell(
          Text(thousandDot(list[index].sotien)),
          onTap: () => onTap(index: list[index].makm),
        ),
        DataCell(
          Column(
            children: [
              Text(list[index].ngaybatdau.toString()),
              Text(list[index].ngayhethan.toString()),
            ],
          ),
          onTap: () => onTap(index: list[index].makm),
        ),
        DataCell(
          Column(
            children: [
              Text(thousandDot(list[index].conlai)),
              Text(thousandDot(list[index].soluong)),
            ],
          ),
          onTap: () => onTap(index: list[index].makm),
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

class AlertDialogMin extends StatefulWidget {
  final String id;
  final Future<void> Function() callback;

  const AlertDialogMin({
    Key? key,
    required this.id,
    required this.callback,
  }) : super(key: key);

  @override
  State<AlertDialogMin> createState() => _AlertDialogMinState();
}

class _AlertDialogMinState extends State<AlertDialogMin> {
  int soluong = 0;

  bool isNum = true;

  final TextStyle baseTextStyle = const TextStyle(fontSize: 20.0);

  final double widthSpaceInput = 50.0;

  final double heightInput = 20.0;

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/khuyenMai/ton"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaKM': widget.id,
        'SoLuong': soluong,
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
          message: 'Thêm dữ liệu thất bại',
          messageSize: 20.0,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade900,
        ).show(context);
      }
    }
  }

  Future<void> xoaDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/khuyenMai/ton"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaKM': widget.id,
        'SoLuong': soluong,
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

  Future<void> xoaDuLieuGoc() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/khuyenMai"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaKM': widget.id,
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
              SizedBox(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.titleLarge,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
                  ],
                  decoration: InputDecoration(
                    labelText: "Số lượng tồn",
                    errorText: isNum ? null : "Nhập số vào",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: ((value) {
                    final check = int.tryParse(value);
                    if (check == null) {
                      setState(() {
                        isNum = false;
                      });
                    } else {
                      setState(() {
                        isNum = true;
                        soluong = check;
                      });
                    }
                  }),
                ),
              ),
              SizedBox(height: heightInput),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: widthSpaceInput,
                      child: ElevatedButton(
                        onPressed: () async => await themDuLieu(),
                        child: Text("Thêm", style: baseTextStyle),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: widthSpaceInput,
                      child: ElevatedButton(
                        onPressed: () async => await xoaDuLieu(),
                        child: Text("Xóa", style: baseTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              SizedBox(
                width: double.infinity,
                height: widthSpaceInput,
                child: ElevatedButton(
                  onPressed: (() async => await xoaDuLieuGoc()),
                  child: Text("Xóa khuyến mãi", style: baseTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
