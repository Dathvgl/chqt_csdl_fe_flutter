import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_crm/model/khachhang.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class KhachHangThuongPage extends StatefulWidget {
  const KhachHangThuongPage({Key? key}) : super(key: key);

  @override
  State<KhachHangThuongPage> createState() => _KhachHangThuongPageState();
}

class _KhachHangThuongPageState extends State<KhachHangThuongPage> {
  DataTableSource data = KhachHangHomeData();

  @override
  void initState() {
    super.initState();
    danhSach();
  }

  void customDialog() {
    showDialog(
      context: context,
      builder: (_) => KhachHangAlert(
        callback: danhSach,
      ),
    );
  }

  Future<void> danhSach() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/khachHang"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<KhachHangTraCuuModel> danhSachList = [];

      for (final item in list) {
        danhSachList.add(KhachHangTraCuuModel.fromMap(map: item));
      }

      KhachHangHomeData homeData = KhachHangHomeData(list: danhSachList);
      homeData.context = context;
      homeData.callback = danhSach;

      setState(() {
        data = homeData;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Lấy danh sách dữ liệu thất bại",
        );
      }
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
            header: const Text("Danh sách khách hàng"),
            columns: const [
              DataColumn(
                label: Text("Mã KH/TV"),
              ),
              DataColumn(
                label: Text("Họ và tên"),
              ),
              DataColumn(
                label: Text("Loại thẻ"),
              ),
              DataColumn(
                label: Text("Ngày sinh"),
              ),
              DataColumn(
                label: Text("Giới tính"),
              ),
              DataColumn(
                label: Text("Quốc gia"),
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

class KhachHangAlert extends StatefulWidget {
  final VoidCallback callback;

  const KhachHangAlert({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<KhachHangAlert> createState() => _KhachHangAlertState();
}

class _KhachHangAlertState extends State<KhachHangAlert> {
  KhachHangModel instance = KhachHangModel(
    maqt: 192,
    hoten: "",
    ngaysinh: "",
    cccd: "",
  );

  List<List<KhachHangThongTin>> thongtin = [];

  List<DropdownMenuItem<int>>? quoctich;
  List<DropdownMenuItem<int>>? tinhthanhpho;
  List<DropdownMenuItem<int>>? quanhuyen = [];
  List<DropdownMenuItem<int>>? phuongxa = [];

  final double widthInput = 250.0;
  final double widthSpaceInput = 50.0;

  final double heightInput = 20.0;

  DateTime selectedDate = DateTime.now();
  TextEditingController date = TextEditingController();

  @override
  void initState() {
    super.initState();
    thongTin();
  }

  Future<void> thongTin() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/khachHang/thongTin"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = [];
      ThongTinModel info;
      ThongTinModel born = ThongTinModel();
      Map<String, dynamic> map = jsonDecode(response.body);

      list = jsonDecode(map["quoctich"]);
      for (final item in list) {
        born.addData(KhachHangThongTin(ThongTinType.quocTich, item));
      }

      list = jsonDecode(map["thanhpho"]);
      List<TinhThanhPhoModel> danhSachTinhThanhPho = [];
      for (final item in list) {
        danhSachTinhThanhPho.add(TinhThanhPhoModel.fromMap(map: item));
      }
      var danhSachThanhPho = danhSachTinhThanhPho
        ..sort((a, b) => a.ten.toLowerCase().compareTo(b.ten.toLowerCase()));

      info = ThongTinModel();
      list = jsonDecode(map["quanhuyen"]);
      for (final item in list) {
        info.addData(KhachHangThongTin(ThongTinType.quanHuyen, item));
      }
      thongtin.add(info.datas);

      info = ThongTinModel();
      list = jsonDecode(map["phuongxa"]);
      for (final item in list) {
        info.addData(KhachHangThongTin(ThongTinType.phuongXa, item));
      }
      thongtin.add(info.datas);

      setState(() {
        quoctich = born.datas
            .map(
              (e) => DropdownMenuItem(
                value: e.ma,
                child: Text(e.ten),
              ),
            )
            .toList();
        tinhthanhpho = danhSachThanhPho
            .map(
              (e) => DropdownMenuItem(
                value: e.ma,
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
      Uri.parse("${url!}/khachHang"),
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      final url = DateFormat('dd/MM/yyyy');

      setState(() {
        selectedDate = picked;
        date.value = TextEditingValue(
          text: url.format(picked),
        );
        instance.ngaysinh = picked.toString();
      });
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
                    child: KhachHangThemSelect(
                      label: "Quốc tịch",
                      pk: instance.maqt,
                      list: quoctich,
                      callback: ((value) {
                        if (value is int) {
                          setState(() {
                            instance.maqt = value;
                          });
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: widthInput,
                    child: KhachHangThemSelect(
                      label: "Tỉnh / Thành phố",
                      pk: instance.matp,
                      list: tinhthanhpho,
                      callback: ((value) {
                        if (value is int) {
                          setState(() {
                            instance.matp = value;
                            instance.maqh = null;
                            instance.mapx = null;

                            final List<KhachHangThongTin> list =
                                List<KhachHangThongTin>.from(thongtin[0])
                                    .where((e) => e.maPhu == value)
                                    .toList()
                                  ..sort((a, b) => a.ten
                                      .toLowerCase()
                                      .compareTo(b.ten.toLowerCase()));
                            quanhuyen = list
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.ma,
                                    child: Text(e.ten),
                                  ),
                                )
                                .toList();
                          });
                        }
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              Row(
                children: [
                  SizedBox(
                    width: widthInput,
                    child: KhachHangThemSelect(
                      label: "Quận / Huyện",
                      pk: instance.maqh,
                      fk: instance.matp,
                      list: quanhuyen,
                      callback: ((value) {
                        if (value is int) {
                          setState(() {
                            instance.maqh = value;
                            instance.mapx = null;

                            final List<KhachHangThongTin> list =
                                List<KhachHangThongTin>.from(thongtin[1])
                                    .where((e) => e.maPhu == value)
                                    .toList()
                                  ..sort((a, b) => a.ten
                                      .toLowerCase()
                                      .compareTo(b.ten.toLowerCase()));
                            phuongxa = list
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.ma,
                                    child: Text(e.ten),
                                  ),
                                )
                                .toList();
                          });
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: widthInput,
                    child: KhachHangThemSelect(
                      label: "Phường / Xã",
                      pk: instance.mapx,
                      fk: instance.maqh,
                      list: phuongxa,
                      callback: ((value) {
                        if (value is int) {
                          setState(() {
                            instance.mapx = value;
                          });
                        }
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              Row(
                children: [
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "Họ và tên",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          instance.hoten = value;
                        });
                      }),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: 150.0,
                    child: GestureDetector(
                      onTap: () => selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: date,
                          keyboardType: TextInputType.datetime,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: const InputDecoration(
                            labelText: "Ngày sinh",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              Row(
                children: [
                  SizedBox(
                    width: widthInput,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          items: const [
                            DropdownMenuItem(
                              value: "Nam",
                              child: Text("Nam"),
                            ),
                            DropdownMenuItem(
                              value: "Nữ",
                              child: Text("Nữ"),
                            ),
                          ],
                          isExpanded: true,
                          hint: const Text("Giới tính"),
                          value: instance.gioitinh,
                          onChanged: ((value) {
                            setState(() {
                              if (value is String) {
                                instance.gioitinh = value;
                              }
                            });
                          }),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: widthInput,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "CCCD",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          instance.cccd = value;
                        });
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              TextField(
                keyboardType: TextInputType.streetAddress,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: const InputDecoration(
                  labelText: "Số nhà",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onChanged: ((value) {
                  setState(() {
                    instance.sonha = value == "" ? null : value;
                  });
                }),
              ),
              SizedBox(height: heightInput),
              Row(
                children: [
                  SizedBox(
                    width: widthInput,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          instance.email = value == "" ? null : value;
                        });
                      }),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: widthInput,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "Số điện thoại",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          instance.dienthoai = value == "" ? null : value;
                        });
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              SizedBox(
                width: widthInput,
                height: widthSpaceInput,
                child: ElevatedButton(
                  onPressed: (() async {
                    if (instance.maqt == null ||
                        instance.matp == null ||
                        instance.maqh == null ||
                        instance.mapx == null ||
                        instance.hoten == "" ||
                        instance.ngaysinh == "" ||
                        instance.gioitinh == null ||
                        instance.cccd == "") {
                      Flushbar(
                        message: 'Dữ liệu khách hàng không đủ',
                        messageSize: 20.0,
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red.shade900,
                      ).show(context);
                    } else {
                      await themDuLieu();
                    }
                  }),
                  child: const Text(
                    "Thêm khách hàng",
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

class KhachHangThemSelect extends StatelessWidget {
  final String label;
  final int? pk;
  final int? fk;
  final List<DropdownMenuItem<int>>? list;
  final Function(int?) callback;

  const KhachHangThemSelect({
    Key? key,
    required this.label,
    this.pk,
    this.fk = 0,
    this.list,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          items: list,
          isExpanded: true,
          hint: Text(label),
          value: pk,
          onChanged: fk == null ? null : callback,
        ),
      ),
    );
  }
}
