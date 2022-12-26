import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/model/khuyenmai.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class KhuyenMaiThuongPage extends StatefulWidget {
  const KhuyenMaiThuongPage({Key? key}) : super(key: key);

  @override
  State<KhuyenMaiThuongPage> createState() => _KhuyenMaiThuongPageState();
}

class _KhuyenMaiThuongPageState extends State<KhuyenMaiThuongPage> {
  DataTableSource data = KhuyenMaiHomeData();

  @override
  void initState() {
    super.initState();
    danhSach();
  }

  void customDialog() {
    showDialog(
      context: context,
      builder: (_) => KhuyenMaiAlert(
        callback: danhSach,
      ),
    );
  }

  Future<void> danhSach() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/khuyenMai"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<KhuyenMaiTraCuuModel> danhSachList = [];

      for (final item in list) {
        danhSachList.add(KhuyenMaiTraCuuModel.fromMap(map: item));
      }

      KhuyenMaiHomeData homeData = KhuyenMaiHomeData(list: danhSachList);
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
            header: const Text("Danh sách khuyến mãi"),
            columns: const [
              DataColumn(
                label: Text("Mã KM"),
              ),
              DataColumn(
                label: Text("Tên khuyến mãi"),
              ),
              DataColumn(
                label: Text("Số tiền"),
              ),
              DataColumn(
                label: Text("Ngày khuyến mãi"),
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

class KhuyenMaiAlert extends StatefulWidget {
  final VoidCallback callback;

  const KhuyenMaiAlert({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<KhuyenMaiAlert> createState() => _KhuyenMaiAlertState();
}

class _KhuyenMaiAlertState extends State<KhuyenMaiAlert> {
  KhuyenMaiModel instance = KhuyenMaiModel(
    ten: "",
    sotien: 0,
  );

  bool isNum = true;

  final double widthInput = 250.0;
  final double widthSpaceInput = 50.0;

  final double heightInput = 20.0;

  DateTime selectedDate = DateTime.now();
  TextEditingController date = TextEditingController();

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/khuyenMai"),
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

  void dateSet(int index, String value) {
    switch (index) {
      case 0:
        setState(() {
          instance.ngaybatdau = value;
        });
        break;
      case 1:
        setState(() {
          instance.ngayhethan = value;
        });
        break;
      default:
        break;
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
                    child: TextField(
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "Tên khuyến mãi",
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
                            instance.sotien = check;
                          });
                        }
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectDateAlert(
                    index: 0,
                    label: "Ngày bắt đầu",
                    callback: dateSet,
                  ),
                  SizedBox(width: widthSpaceInput),
                  SelectDateAlert(
                    index: 1,
                    label: "Ngày hết hạn",
                    callback: dateSet,
                  ),
                ],
              ),
              SizedBox(height: heightInput),
              SizedBox(
                width: double.infinity,
                height: widthSpaceInput,
                child: ElevatedButton(
                  onPressed: (() async {
                    if (instance.ten == "" ||
                        instance.sotien == 0 ||
                        instance.ngaybatdau == "" ||
                        instance.ngayhethan == "") {
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
                    "Thêm khuyến mãi",
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

class SelectDateAlert extends StatefulWidget {
  final int index;
  final String label;
  final Function(int, String) callback;

  const SelectDateAlert({
    Key? key,
    required this.index,
    required this.label,
    required this.callback,
  }) : super(key: key);

  @override
  State<SelectDateAlert> createState() => _SelectDateAlertState();
}

class _SelectDateAlertState extends State<SelectDateAlert> {
  DateTime selectedDate = DateTime.now();
  TextEditingController date = TextEditingController();

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
      });

      widget.callback(widget.index, url.format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: GestureDetector(
        onTap: () => selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: date,
            keyboardType: TextInputType.datetime,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
