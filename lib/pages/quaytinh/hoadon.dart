import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crm/function.dart';
import 'package:flutter_crm/model/hoadon.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:number_inc_dec/number_inc_dec.dart';

class HoaDonTinhPage extends StatefulWidget {
  const HoaDonTinhPage({Key? key}) : super(key: key);

  @override
  State<HoaDonTinhPage> createState() => _HoaDonTinhPageState();
}

class _HoaDonTinhPageState extends State<HoaDonTinhPage> {
  HoaDonModel hoaDon = HoaDonModel();

  int itemCountHD = 0;
  int itemCountKM = 0;

  final TextEditingController matv = TextEditingController();

  final double widthInput = 200.0;
  final double spaceInput = 50.0;

  final double heightInput = 20.0;

  Future<void> thongTin() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.get(
      Uri.parse("${url!}/hoaDon/${hoaDon.instance.mahd}"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);

      setState(() {
        hoaDon.instance.fromMap(map: list[0]);
      });
    } else {
      debugPrint("Failed");
    }
  }

  Future<void> themDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/hoaDon"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaTV': hoaDon.instance.matv,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thành công",
        );
      }

      Map<String, dynamic> map = jsonDecode(response.body);
      setState(() {
        hoaDon.instance.mahd = map["id"];
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> xoaDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/hoaDon"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': hoaDon.instance.mahd,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thành công",
        );
      }

      setState(() {
        matv.clear();
        itemCountHD = 0;
        itemCountKM = 0;
        hoaDon.instance.clear();
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> capNhatThe() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.put(
      Uri.parse("${url!}/hoaDon/the"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': hoaDon.instance.mahd,
        'MaTV': hoaDon.instance.matv,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Cập nhật dữ liệu thành công",
        );
      }

      await thongTin();
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Cập nhật dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> capNhatDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.put(
      Uri.parse("${url!}/hoaDon"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': hoaDon.instance.mahd,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Cập nhật dữ liệu thành công",
        );
      }

      setState(() {
        matv.clear();
        itemCountHD = 0;
        itemCountKM = 0;
        hoaDon.instance.clear();
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Cập nhật dữ liệu thất bại",
        );
      }
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widthInput,
                  child: TextField(
                    controller: matv,
                    keyboardType: TextInputType.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: const InputDecoration(
                      labelText: "Mã thành viên",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      hoaDon.instance.matv = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: widthInput,
                  height: spaceInput,
                  child: ElevatedButton(
                    onPressed: () async => await capNhatThe(),
                    child: const Text(
                      "Cập nhật thẻ",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthInput,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: spaceInput,
                          child: ElevatedButton(
                            onPressed: () async => await themDuLieu(),
                            child: const Text(
                              "Tạo",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: spaceInput,
                          child: ElevatedButton(
                            onPressed: () async => await xoaDuLieu(),
                            child: const Text(
                              "Xóa",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: heightInput),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thành tiền: ${thousandDot(hoaDon.instance.thanhtien)} đ",
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Thanh toán: ${thousandDot(hoaDon.instance.thanhtoan)} đ",
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: widthInput,
                  height: spaceInput,
                  child: ElevatedButton(
                    onPressed: () async => await capNhatDuLieu(),
                    child: const Text(
                      "Thanh toán",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heightInput),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemCountHD,
                        itemBuilder: ((context, index) {
                          return Dismissible(
                            key: Key(index.toString()),
                            child: ItemBuilderHD(
                              mahd: hoaDon.instance.mahd,
                              thongTin: thongTin,
                            ),
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: heightInput);
                        },
                      ),
                      SizedBox(height: heightInput),
                      SizedBox(
                        width: widthInput + spaceInput,
                        height: spaceInput,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            itemCountHD += 1;
                          }),
                          child: const Text(
                            "Thêm chi tiết hóa đơn",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemCountKM,
                        itemBuilder: ((context, index) {
                          return ItemBuilderKM(
                            mahd: hoaDon.instance.mahd,
                            thongTin: thongTin,
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: heightInput);
                        },
                      ),
                      SizedBox(height: heightInput),
                      SizedBox(
                        width: widthInput + spaceInput,
                        height: spaceInput,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            itemCountKM += 1;
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemBuilderHD extends StatefulWidget {
  final String mahd;
  final Future<void> Function() thongTin;

  const ItemBuilderHD({
    Key? key,
    required this.mahd,
    required this.thongTin,
  }) : super(key: key);

  @override
  State<ItemBuilderHD> createState() => _ItemBuilderHDState();
}

class _ItemBuilderHDState extends State<ItemBuilderHD> {
  final double spaceInput = 10.0;
  final double itemRow = 350.0;

  bool isDone = false;
  bool isCancel = false;

  String masp = '';
  int soluong = 1;

  Future<void> themDuLieu() async {
    if (isDone) return;

    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/hoaDon/sp"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': widget.mahd,
        'MaSP': masp,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thành công",
        );
      }

      widget.thongTin();
      setState(() {
        isDone = true;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> xoaDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/hoaDon/sp"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': widget.mahd,
        'MaSP': masp,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thành công",
        );
      }

      widget.thongTin();
      setState(() {
        isCancel = true;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> capNhatDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.put(
      Uri.parse("${url!}/hoaDon/sp"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': widget.mahd,
        'MaSP': masp,
        'SoLuong': soluong,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thay đổi dữ liệu thành công",
        );
      }

      widget.thongTin();
      setState(() {
        isDone = true;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thay đổi dữ liệu thất bại",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCancel ? Colors.black26 : null,
      child: Column(
        children: [
          SizedBox(
            width: itemRow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150.0,
                  child: TextField(
                    enabled: !isDone || !isCancel,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: const InputDecoration(
                      labelText: "Mã sản phẩm",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      masp = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: 125.0,
                  child: NumberInputWithIncrementDecrement(
                    min: 1,
                    initialValue: 1,
                    enabled: !isCancel,
                    onIncrement: (newValue) => setState(() {
                      soluong = newValue.toInt();
                    }),
                    onDecrement: (newValue) => setState(() {
                      soluong = newValue.toInt();
                    }),
                    controller: TextEditingController(),
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spaceInput),
          SizedBox(
            width: itemRow,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      return isCancel ? null : await themDuLieu();
                    },
                    child: const Text(
                      "Thêm",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      return isCancel ? null : await capNhatDuLieu();
                    },
                    child: const Text(
                      "Cập nhật",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      return isCancel ? null : await xoaDuLieu();
                    },
                    child: const Text(
                      "Xóa",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemBuilderKM extends StatefulWidget {
  final String mahd;
  final Future<void> Function() thongTin;

  const ItemBuilderKM({
    Key? key,
    required this.mahd,
    required this.thongTin,
  }) : super(key: key);

  @override
  State<ItemBuilderKM> createState() => _ItemBuilderKMState();
}

class _ItemBuilderKMState extends State<ItemBuilderKM> {
  bool isDone = false;
  bool isCancel = false;

  String makm = '';

  Future<void> themDuLieu() async {
    if (isDone) return;

    String? url = dotenv.env["SERVER"];

    final response = await http.post(
      Uri.parse("${url!}/hoaDon/km"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': widget.mahd,
        'MaKM': makm,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thành công",
        );
      }

      widget.thongTin();
      setState(() {
        isDone = true;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Thêm dữ liệu thất bại",
        );
      }
    }
  }

  Future<void> xoaDuLieu() async {
    String? url = dotenv.env["SERVER"];

    final response = await http.delete(
      Uri.parse("${url!}/hoaDon/km"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaHD': widget.mahd,
        'MaKM': makm,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thành công",
        );
      }

      widget.thongTin();
      setState(() {
        isCancel = true;
      });
    } else {
      if (mounted) {
        snackBar(
          context: context,
          text: "Xóa dữ liệu thất bại",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCancel ? Colors.black26 : null,
      child: Column(
        children: [
          SizedBox(
            width: 350.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 170.0,
                  child: TextField(
                    enabled: !isDone || !isCancel,
                    keyboardType: TextInputType.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: const InputDecoration(
                      labelText: "Mã khuyến mãi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      makm = value;
                    }),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          return isCancel ? null : await themDuLieu();
                        },
                        child: const Text(
                          "Thêm",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          return isCancel ? null : await xoaDuLieu();
                        },
                        child: const Text(
                          "Xóa",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
