import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListViewWidget extends StatelessWidget {
  int countLength;
  List<List> list;

  ListViewWidget({Key key, this.countLength, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: countLength,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).canvasColor,
              elevation: 2,
              child: ListTile(
                  leading: Text(
                    "${i + 1}-",
                  ),
                  title: Text(
                    list[i][0],
                  ),
                  subtitle: Text(
                    list[i][1],
                  )),
            ),
          );
        },
      ),
    );
  }
}
