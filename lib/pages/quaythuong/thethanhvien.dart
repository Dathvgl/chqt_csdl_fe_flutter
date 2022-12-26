import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/model/thethanhvien.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TheThanhVienThuongPage extends StatefulWidget {
  const TheThanhVienThuongPage({Key? key}) : super(key: key);

  @override
  State<TheThanhVienThuongPage> createState() => _TheThanhVienThuongPageState();
}

class _TheThanhVienThuongPageState extends State<TheThanhVienThuongPage> {
  TheThanhVienSelect based = const TheThanhVienSelect();
  List<Widget> instances = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: instances,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          instances.add(based.clone());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TheThanhVienSelect extends StatefulWidget {
  const TheThanhVienSelect({Key? key}) : super(key: key);

  TheThanhVienSelect copyWith() => const TheThanhVienSelect();

  TheThanhVienSelect clone() => copyWith();

  @override
  State<TheThanhVienSelect> createState() => _TheThanhVienSelectState();
}

class _TheThanhVienSelectState extends State<TheThanhVienSelect> {
  List<DropdownMenuItem<int>>? loaithe;

  int maltv = 1;

  @override
  void initState() {
    super.initState();
    thongTin();
  }

  void customDialog() {
    showDialog(
      context: context,
      builder: (_) => TheThanhVienAlert(
        maltv: maltv,
        callback: () {},
      ),
    );
  }

  Future<void> thongTin() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/theThanhVien/loaiThe/thongTin"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<LoaiThanhVienModel> danhSachList = [];

      for (final item in list) {
        danhSachList.add(LoaiThanhVienModel.fromMap(map: item));
      }

      setState(() {
        loaithe = danhSachList
            .map(
              (e) => DropdownMenuItem(
                value: e.maltv,
                child: Text(e.ten),
              ),
            )
            .toList();
      });
    } else {
      debugPrint("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => customDialog(),
          child: Container(
            width: 200.0,
            height: 125.0,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 200.0,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: maltv,
                items: loaithe,
                isExpanded: true,
                hint: const Text("Loại thẻ"),
                onChanged: (value) => setState(() {
                  maltv = value as int;
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TheThanhVienAlert extends StatefulWidget {
  final int maltv;
  final VoidCallback callback;

  const TheThanhVienAlert({
    Key? key,
    required this.maltv,
    required this.callback,
  }) : super(key: key);

  @override
  State<TheThanhVienAlert> createState() => _TheThanhVienAlertState();
}

class _TheThanhVienAlertState extends State<TheThanhVienAlert> {
  String makh = "";
  String taikhoan = "";
  String matkhau = "";

  bool isNum = true;

  final double widthInput = 200.0;

  final TextEditingController checkmakh = TextEditingController();

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/theThanhVien"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaKH': makh,
        'MaLTV': widget.maltv,
        'TaiKhoan': taikhoan,
        'MatKhau': matkhau,
      }),
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
              SizedBox(
                width: widthInput,
                child: TextField(
                  controller: checkmakh,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    labelText: "Mã thành viên",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    makh = value;
                  }),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: widthInput,
                child: TextField(
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    labelText: "Tài khoản",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    taikhoan = value;
                  }),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: widthInput,
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    matkhau = value;
                  }),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: (() async => await themDuLieu()),
                  child: const Text(
                    "Thêm thẻ",
                    style: TextStyle(fontSize: 20.0),
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
