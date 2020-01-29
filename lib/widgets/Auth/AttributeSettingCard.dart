import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';

class AttributeSettingCard extends StatefulWidget {
  final User user;

  AttributeSettingCard({this.user});

  @override
  _AttributeSettingCardState createState() => _AttributeSettingCardState();
}

class _AttributeSettingCardState extends State<AttributeSettingCard> {
  int _gender = 0;
  DateTime pickedDOB;
  TextEditingController majorController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.user?.name ?? "";
    majorController.text = widget.user?.major ?? "";
    _gender = widget.user.gender;
    pickedDOB = Utils.getDateTime(widget?.user?.dob) ?? DateTime.now();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    majorController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // initialValue: widget.user?.major ?? "",
              decoration: const InputDecoration(
                labelText: "姓名",
              ),
              controller: nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                var picked = await showDatePicker(
                  initialDate: pickedDOB,
                  context: context,
                  firstDate: DateTime(1900, 1),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    pickedDOB = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "生日",
                ),
                child: Row(
                  children: <Widget>[
                    Text(DateFormat.yMMMMd()
                        .format(pickedDOB ?? DateTime.now())),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // initialValue: widget.user?.major ?? "",
              decoration: const InputDecoration(
                labelText: "主修",
              ),
              controller: majorController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("性別"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<int>(
                    value: _gender,
                    onChanged: (v) {
                      setState(() {
                        _gender = v;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Text("女"),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text("男"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("更新使用者資料中..."),
                duration: Duration(seconds: 3),
              ));

              Provider.of<UserGolangService>(context, listen: false).updateUser(
                widget.user.id,
                {
                  "dob": pickedDOB.toUtc().toString(),
                  "gender": _gender,
                  "major": majorController.text,
                  "name": nameController.text,
                },
              );
              Navigator.popUntil(context, ModalRoute.withName("/"));
              // Navigator.of(context).pop(true);
            },
            child: Text("確認"),
          )
        ],
      )),
    );
  }
}
