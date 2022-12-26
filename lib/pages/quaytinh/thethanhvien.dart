import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_crm/model/thethanhvien.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TheThanhVienTinhPage extends StatefulWidget {
  const TheThanhVienTinhPage({Key? key}) : super(key: key);

  @override
  State<TheThanhVienTinhPage> createState() => _TheThanhVienTinhPageState();
}

class _TheThanhVienTinhPageState extends State<TheThanhVienTinhPage> {
  TheThanhVienTraCuuModel instance = TheThanhVienTraCuuModel();

  bool isSearch = false;

  final TextEditingController matv = TextEditingController();

  final TextStyle baseTextStyle = const TextStyle(fontSize: 20.0);

  final double widthInput = 200.0;
  final double spaceInput = 50.0;

  Future<void> thongTin() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/theThanhVien/${instance.matv}"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);

      setState(() {
        isSearch = true;
        instance = TheThanhVienTraCuuModel.fromMap(map: list[0]);
      });
    } else {
      debugPrint("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    onChanged: (value) => setState(() {
                      instance.matv = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: widthInput,
                  height: spaceInput,
                  child: ElevatedButton(
                    onPressed: () async => await thongTin(),
                    child: Text("Tra cứu", style: baseTextStyle),
                  ),
                ),
                SizedBox(
                  width: widthInput,
                  height: spaceInput,
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      matv.clear();
                      isSearch = false;
                      instance = TheThanhVienTraCuuModel();
                    }),
                    child: Text("Làm mới", style: baseTextStyle),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: isSearch
                  ? TheThanhVienChiTiet(instance: instance)
                  : Text("Chưa tra cứu", style: baseTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class TheThanhVienChiTiet extends StatelessWidget {
  final TheThanhVienTraCuuModel instance;

  final TextStyle baseHeadStyle = const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );

  final TextStyle baseTextStyle = const TextStyle(fontSize: 20.0);

  Widget baseCell({required Widget widget}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: widget,
      ),
    );
  }

  const TheThanhVienChiTiet({
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    "Họ và tên",
                    style: baseHeadStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    "Loại thẻ",
                    style: baseHeadStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    "Giảm giá",
                    style: baseHeadStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    instance.hoten,
                    style: baseTextStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    instance.loaithe,
                    style: baseTextStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    thousandDot(instance.giamgia),
                    style: baseTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30.0),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    "Tỷ lệ tích",
                    style: baseHeadStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    "Tỷ lệ đổi",
                    style: baseHeadStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    thousandDot(instance.tyletich),
                    style: baseTextStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    thousandDot(instance.tyledoi),
                    style: baseTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    "Tích điểm",
                    style: baseHeadStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    "Điểm hiện có",
                    style: baseHeadStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                baseCell(
                  widget: Text(
                    thousandDot(instance.tichdiem),
                    style: baseTextStyle,
                  ),
                ),
                baseCell(
                  widget: Text(
                    thousandDot(instance.diemtich),
                    style: baseTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
