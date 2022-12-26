import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/model/sanpham.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SanPhamThuongPage extends StatefulWidget {
  const SanPhamThuongPage({Key? key}) : super(key: key);

  @override
  State<SanPhamThuongPage> createState() => _SanPhamThuongPageState();
}

class _SanPhamThuongPageState extends State<SanPhamThuongPage> {
  DataTableSource data = SanPhamHomeData();

  @override
  void initState() {
    super.initState();
    danhSach();
  }

  void customDialog() {
    showDialog(
      context: context,
      builder: (_) => SanPhamAlert(
        callback: danhSach,
      ),
    );
  }

  Future<void> danhSach() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/sanPham"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<SanPhamTraCuuModel> danhSachList = [];

      for (final item in list) {
        danhSachList.add(SanPhamTraCuuModel.fromMap(map: item));
      }

      SanPhamHomeData homeData = SanPhamHomeData(list: danhSachList);
      homeData.context = context;
      homeData.callback = danhSach;

      setState(() {
        data = homeData;
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
            header: const Text("Danh sách sản phẩm"),
            columns: const [
              DataColumn(
                label: Text("Loại sản phẩm"),
              ),
              DataColumn(
                label: Text("Tên sản phẩm"),
              ),
              DataColumn(
                label: Text("Giá tiền"),
              ),
              DataColumn(
                label: Text("Sản lượng"),
              ),
            ],
            rowsPerPage: 5,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => customDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SanPhamAlert extends StatefulWidget {
  final VoidCallback callback;

  const SanPhamAlert({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<SanPhamAlert> createState() => _SanPhamAlertState();
}

class _SanPhamAlertState extends State<SanPhamAlert> {
  SanPhamModel instance = SanPhamModel();

  int soluong = 0;

  bool isNum = true;

  List<DropdownMenuItem<int>>? loaisanpham;

  final double widthInput = 250.0;
  final double widthSpaceInput = 50.0;

  final double heightInput = 20.0;

  @override
  void initState() {
    super.initState();
    thongTin();
  }

  Future<void> thongTin() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/sanPham/thongTin"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<LoaiSanPhamModel> danhSach = [];

      for (final item in list) {
        danhSach.add(LoaiSanPhamModel.fromMap(map: item));
      }

      setState(() {
        loaisanpham = danhSach
            .map(
              (e) => DropdownMenuItem(
                value: e.malsp,
                child: Text(e.ten),
              ),
            )
            .toList();
      });
    } else {
      debugPrint("Failed");
    }
  }

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/sanPham"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(instance.toMap()),
    );

    if (response.statusCode == 200) {
      widget.callback();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      Flushbar(
        message: 'Thêm dữ liệu thất bại',
        messageSize: 20.0,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red.shade900,
      );
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
              Row(
                children: [
                  SizedBox(
                    width: widthInput,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: instance.malsp,
                          items: loaisanpham,
                          isExpanded: true,
                          hint: const Text("Loại sản phẩm"),
                          onChanged: (value) => setState(() {
                            if (value is int) {
                              instance.malsp = value;
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: 120.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.titleLarge,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d?')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Số tiền",
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
                            instance.gia = check;
                          });
                        }
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    labelText: "Tên sản phẩm",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: ((value) {
                    setState(() {
                      instance.ten = value;
                    });
                  }),
                ),
              ),
              SizedBox(height: heightInput),
              SizedBox(
                width: double.infinity,
                height: widthSpaceInput,
                child: ElevatedButton(
                  onPressed: (() async {
                    if (instance.ten == "" || instance.gia == 0) {
                      Flushbar(
                        message: 'Dữ liệu khuyến mãi không đủ',
                        messageSize: 20.0,
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red.shade900,
                      ).show(context);
                    } else {
                      await themDuLieu();
                    }
                  }),
                  child: const Text(
                    "Thêm sản phẩm",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
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
