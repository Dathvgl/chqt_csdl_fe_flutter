import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crm/model/hoaDon.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HoaDonThuongPage extends StatefulWidget {
  const HoaDonThuongPage({Key? key}) : super(key: key);

  @override
  State<HoaDonThuongPage> createState() => _HoaDonThuongPageState();
}

class _HoaDonThuongPageState extends State<HoaDonThuongPage> {
  DataTableSource data = HoaDonHomeData();

  @override
  void initState() {
    super.initState();
    danhSach();
  }

  Future<void> danhSach() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/hoaDon"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<HoaDonModel> danhSach = [];

      for (final item in list) {
        danhSach.add(HoaDonModel.fromMap(map: item));
      }

      setState(() {
        data = HoaDonHomeData(list: danhSach);
      });
    } else {
      debugPrint("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: PaginatedDataTable(
            source: data,
            header: const Text("Danh sách hóa đơn"),
            columns: const [
              DataColumn(
                label: Text("Mã hóa đơn"),
              ),
              DataColumn(
                label: Text("Mã thành viên"),
              ),
              DataColumn(
                label: Text("Ngày hóa đơn"),
              ),
              DataColumn(
                label: Text("Thành tiền"),
              ),
              DataColumn(
                label: Text("Thanh toán"),
              ),
            ],
            rowsPerPage: 5,
          ),
        ),
      ),
    );
  }
}
