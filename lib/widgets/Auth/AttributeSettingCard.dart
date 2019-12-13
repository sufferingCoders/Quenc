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
  final List<String> _allGenders = ["male", "female"];
  String _gender = "male";
  DateTime pickedDOB = DateTime.now();
  TextEditingController majorController = TextEditingController();

  @override
  void initState() {
    majorController.text = widget.user?.major ?? "";

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
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "性別",
                hintText: "選擇你的性別",
              ),
              isEmpty: _gender == null || _gender.isEmpty,
              child: DropdownButton<String>(
                value: widget.user?.gender ?? _gender,
                onChanged: (v) {
                  setState(() {
                    _gender = v;
                  });
                },
                items: _allGenders
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Text(g == "male" ? "男" : "女"),
                      ),
                    )
                    .toList(),
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
          RaisedButton(
            onPressed: () => UserService().updateCollectionUserData(
              widget.user.uid,
              {
                "dob": pickedDOB,
                "gender": _gender,
                "major": majorController.text,
              },
            ),
            child: Text("確認"),
          )
        ],
      )),
    );
  }
}
