import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm/model/quydoi.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuyDoiThuongPage extends StatefulWidget {
  const QuyDoiThuongPage({Key? key}) : super(key: key);

  @override
  State<QuyDoiThuongPage> createState() => _QuyDoiThuongPageState();
}

class _QuyDoiThuongPageState extends State<QuyDoiThuongPage> {
  DataTableSource data = QuyDoiHomeData();

  @override
  void initState() {
    super.initState();
    danhSach();
  }

  void customDialog() {
    showDialog(
      context: context,
      builder: (_) => QuyDoiAlert(
        callback: danhSach,
      ),
    );
  }

  Future<void> danhSach() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/quyDoi"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<QuyDoiModel> danhSach = [];

      for (final item in list) {
        danhSach.add(QuyDoiModel.fromMap(map: item));
      }

      setState(() {
        data = QuyDoiHomeData(list: danhSach);
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
            header: const Text("Danh sách quy đổi"),
            columns: const [
              DataColumn(
                label: Text("Mã quy đổi"),
              ),
              DataColumn(
                label: Text("Mã thành viên"),
              ),
              DataColumn(
                label: Text("Điểm tích"),
              ),
              DataColumn(
                label: Text("Thành tiền"),
              ),
              DataColumn(
                label: Text("Ngày đổi"),
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

class QuyDoiAlert extends StatefulWidget {
  final VoidCallback callback;

  const QuyDoiAlert({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<QuyDoiAlert> createState() => _QuyDoiAlertState();
}

class _QuyDoiAlertState extends State<QuyDoiAlert> {
  QuyDoiModel instance = QuyDoiModel(
    matv: "",
    diemtich: 0,
  );

  bool isNum = true;

  final double widthInput = 160.0;
  final double widthSpaceInput = 50.0;

  final double heightInput = 20.0;

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/quyDoi"),
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
                    child: TextField(
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        labelText: "Mã thành viên",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          instance.matv = value;
                        });
                      }),
                    ),
                  ),
                  SizedBox(width: widthSpaceInput),
                  SizedBox(
                    width: widthInput,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.titleLarge,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d?')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Điểm tích đổi",
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
                            instance.diemtich = check;
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
                height: widthSpaceInput,
                child: ElevatedButton(
                  onPressed: (() async {
                    if (instance.matv == "" || instance.diemtich == 0) {
                      Flushbar(
                        message: 'Dữ liệu quy đổi không đủ',
                        messageSize: 20.0,
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red.shade900,
                      ).show(context);
                    } else {
                      await themDuLieu();
                    }
                  }),
                  child: const Text(
                    "Thêm quy đổi",
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
