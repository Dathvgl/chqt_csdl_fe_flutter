import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_crm/pages/quaythuong/hoadon.dart';
import 'package:flutter_crm/pages/quaythuong/khachhang.dart';
import 'package:flutter_crm/pages/quaythuong/khuyenmai.dart';
import 'package:flutter_crm/pages/quaythuong/quydoi.dart';
import 'package:flutter_crm/pages/quaythuong/sanpham.dart';
import 'package:flutter_crm/pages/quaythuong/thethanhvien.dart';
import 'package:flutter_crm/pages/quaytinh/hoadon.dart';
import 'package:flutter_crm/pages/quaytinh/thethanhvien.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(900, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String user = "";
  String pass = "";
  String dropValue = "";

  int server = 0;

  final double widthInput = 200.0;
  final double heightInput = 20.0;

  Future<void> thongTin(String user, String pass) async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': user,
        'pass': pass,
        'server': server,
      }),
    );

    if (response.statusCode == 200) {
      String login = response.body;

      if (login.contains("QTh")) {
        setState(() {
          dropValue = "thuong";
        });
      } else {
        setState(() {
          dropValue = "tinh";
        });
      }
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Đăng nhập thất bại",
        );
      }
    }
  }

  void dangXuat() {
    setState(() {
      user = "";
      pass = "";
      dropValue = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dropValue != "") {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: NavPage(
          dropValue: dropValue,
          callback: dangXuat,
        ),
      );
    } else {
      return RawKeyboardListener(
        autofocus: false,
        focusNode: FocusNode(),
        onKey: (value) async {
          if (value.isKeyPressed(LogicalKeyboardKey.enter)) {
            await thongTin(user, pass);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Card(
              elevation: 20.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: widthInput,
                              child: TextField(
                                keyboardType: TextInputType.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                decoration: const InputDecoration(
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                onChanged: (value) => setState(() {
                                  user = value;
                                }),
                              ),
                            ),
                            SizedBox(height: heightInput),
                            SizedBox(
                              width: widthInput,
                              child: TextField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                style: Theme.of(context).textTheme.titleLarge,
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                onChanged: (value) => setState(() {
                                  pass = value;
                                }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: heightInput),
                        Column(
                          children: [
                            SizedBox(
                              width: widthInput,
                              child: RadioListTile(
                                value: 0,
                                groupValue: server,
                                title: const Text('Server 1'),
                                onChanged: (value) => setState(() {
                                  server = value as int;
                                }),
                              ),
                            ),
                            SizedBox(
                              width: widthInput,
                              child: RadioListTile(
                                value: 1,
                                groupValue: server,
                                title: const Text('Server 2'),
                                onChanged: (value) => setState(() {
                                  server = value as int;
                                }),
                              ),
                            ),
                            SizedBox(
                              width: widthInput,
                              child: RadioListTile(
                                value: 2,
                                groupValue: server,
                                title: const Text('Server 3'),
                                onChanged: (value) => setState(() {
                                  server = value as int;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: heightInput),
                    SizedBox(
                      width: widthInput,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async => await thongTin(user, pass),
                        child: const Text(
                          "Đăng nhập",
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
          ),
        ),
      );
    }
  }
}

class NavPage extends StatefulWidget {
  final String dropValue;
  final VoidCallback callback;

  const NavPage({
    Key? key,
    required this.dropValue,
    required this.callback,
  }) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentPage = 0;

  List<DropdownMenuItem<String>> quaySieuThi = [
    const DropdownMenuItem(
      value: "thuong",
      child: Text("Quầy Thường"),
    ),
    const DropdownMenuItem(
      value: "tinh",
      child: Text("Quầy Tính"),
    ),
  ];

  final tabThuong = [
    const KhachHangThuongPage(),
    const TheThanhVienThuongPage(),
    const KhuyenMaiThuongPage(),
    const HoaDonThuongPage(),
    const SanPhamThuongPage(),
    const QuyDoiThuongPage(),
  ];

  final itemThuong = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Khách Hàng',
      backgroundColor: Color(0xFF00838F),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.view_compact_outlined),
      label: 'Thẻ Thành Viên',
      backgroundColor: Colors.indigo,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.discount),
      label: 'Khuyến Mãi',
      backgroundColor: Color(0xFFB71C1C),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.blinds_outlined),
      label: 'Hóa Đơn',
      backgroundColor: Colors.purple,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.maps_home_work_outlined),
      label: 'Sản Phẩm',
      backgroundColor: Color(0xFF2E7D32),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.transfer_within_a_station),
      label: 'Quy Đổi',
      backgroundColor: Colors.brown,
    ),
  ];

  final tabTinh = [
    const HoaDonTinhPage(),
    const TheThanhVienTinhPage(),
  ];

  final itemTinh = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.blinds_outlined),
      label: 'Hóa Đơn',
      backgroundColor: Colors.purple,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.view_compact_outlined),
      label: 'Thẻ Thành Viên',
      backgroundColor: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String dropValue = widget.dropValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý quan hệ khách hàng CO-OP Mart"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.output),
              tooltip: "Đăng xuất",
              onPressed: () => widget.callback(),
            ),
          )
        ],
      ),
      body:
          dropValue == "thuong" ? tabThuong[currentPage] : tabTinh[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: dropValue == "thuong" ? itemThuong : itemTinh,
        currentIndex: currentPage,
        type: BottomNavigationBarType.shifting,
        onTap: (index) => setState(() {
          currentPage = index;
        }),
      ),
    );
  }
}
