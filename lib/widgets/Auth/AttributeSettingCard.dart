import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';

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

  @override
  void initState() {
    majorController.text = widget.user?.major ?? "";
    _gender = widget.user.gender;
    pickedDOB = widget.user.dob;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    majorController.dispose();
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
            child: InkWell(
              onTap: () async {
                var picked = await showDatePicker(
                  initialDate: widget.user?.dob ?? pickedDOB,
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
                labelText: "Major",
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

              UserService().updateCollectionUserData(
                widget.user.id,
                {
                  "dob": pickedDOB,
                  "gender": _gender,
                  "major": majorController.text,
                },
              );

              Navigator.of(context).pop(true);
            },
            child: Text("確認"),
          )
        ],
      )),
    );
  }
}
