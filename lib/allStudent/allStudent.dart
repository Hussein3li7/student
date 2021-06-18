import 'package:flutter/material.dart';
import 'studentStages/Stage1.dart';
import 'studentStages/Stage2.dart';
import 'studentStages/Stage3.dart';
import 'studentStages/Stage4.dart';

class AllStudent extends StatefulWidget {
  @override
  _AllStudentState createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  String type = 'صباحي';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: TabBar(
              tabs: [
                Text("Stage 1"),
                Text("Stage 2"),
                Text("Stage 3"),
                Text("Stage 4"),
              ],
              indicatorPadding: EdgeInsets.all(10),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              labelPadding: EdgeInsets.symmetric(vertical: 10.0),
              unselectedLabelColor: Colors.white,
              indicator: BoxDecoration(
                color: Color(0xff632fad),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.horizontal(
              start: Radius.circular(20),
              end: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: 100.0,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        indicatorPadding: EdgeInsets.all(10),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        labelPadding: EdgeInsets.symmetric(vertical: 10.0),
                        unselectedLabelColor: Colors.grey,
                        indicator: BoxDecoration(
                          color: Color(0xff632fad),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                          ),
                        ),
                        onTap: (i) {
                          setState(() {
                            if (i == 0) {
                              type = "صباحي";
                            } else if (i == 1) {
                              type = "مسائي";
                            }
                          });
                          print(i);
                        },
                        tabs: <Widget>[
                          Tab(
                            text: "صباحي",
                          ),
                          Tab(
                            text: "مسائي",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Stage1(
                      stage: "1",
                      type: type,
                    ),
                    Stage2(
                      stage: "2",
                      type: type,
                    ),
                    Stage3(
                      stage: "3",
                      type: type,
                    ),
                    Stage4(
                      stage: "4",
                      type: type,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
