import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student/service/FirebaseService.dart';
import 'package:student/upluadStudent/ListViewWIdget.dart';

class UpluadStudent extends StatefulWidget {
  UpluadStudent({Key key}) : super(key: key);

  @override
  _UpluadStudentState createState() => _UpluadStudentState();
}

class _UpluadStudentState extends State<UpluadStudent> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String stageValue, stdTypeValue, lesonValue;
  List<String> stage = ["1", "2", "3", "4"];
  List<String> stdType = ["صباحي", "مسائي"];
  List<List> excelValue = [];
  bool loading = false;
  int counter = 0;

  Future readExcelFile() async {
    await FilePicker.getFile(
      type: FileType.any,
    ).then((excelFile) {
      if (excelFile != null) {
        excelValue.clear();
        var bytes = excelFile.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          print(table); //sheet Name
          print(excel.tables[table].maxCols);
          print(excel.tables[table].maxRows);
          setState(() {
            for (var row in excel.tables[table].rows) {
              excelValue.add(row);
            }
          });
        }
      }
    });
  }

  Future upluadToFirebase() async {
    try {
      setState(() {
        loading = true;
      });
      for (var i = 0; i < excelValue.length; i++) {
        await FirebaseService()
            .upluadStudent(stdName: excelValue[i][0])
            .then((s) {
          if (s == "Done") {
            setState(() {
              counter += 1;
            });
          } else {
            resaltSnakbar(s.toString(), Colors.red.shade500);

            setState(() {
              loading = false;
            });
          }
        });
      }
      resaltSnakbar("تم رفع الاسئلة", Colors.green.shade500);
    } catch (e) {
      setState(() {
        loading = false;
      });
      resaltSnakbar(e.toString(), Colors.red.shade500);
    }
  }

  Future resaltSnakbar(String msg, Color color) async {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("$msg"),
        backgroundColor: color,
      ),
    );
    setState(() {
      loading = false;
    });
  }

  Widget dropDownWidgetStages() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton(
        hint: Text(
          'المرحلة',
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        value: stageValue,
        onChanged: (value) {
          setState(() {
            stageValue = value;
          });
        },
        items: stage.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text("المرحلة $e"),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownWidgetstdType() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton(
        hint: Text(
          'نوع الدراسة',
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        value: stdTypeValue,
        onChanged: (value) {
          setState(() {
            stdTypeValue = value;
          });
        },
        items: stdType.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text("نوع الدراسة $e"),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  dropDownWidgetStages(),
                  dropDownWidgetstdType(),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  child: Text(
                    "اختيار اسئلة الصوت",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    await readExcelFile();
                  },
                  color: Colors.deepOrange,
                ),
              ),
              ListViewWidget(
                countLength: excelValue.length,
                list: excelValue,
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: loading
                    ? Container(
                        color: Colors.amber,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            Text("تم رفع $counter"),
                          ],
                        ),
                      )
                    : RaisedButton(
                        child: Text(
                          "رفع الاسئلةالصوت ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          await upluadToFirebase();
                        },
                        color: Colors.green,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
