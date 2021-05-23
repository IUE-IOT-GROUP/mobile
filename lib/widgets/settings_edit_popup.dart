import 'package:flutter/material.dart';

class EditPopup extends StatefulWidget {
  String identifier;
  String value;
  TextEditingController controller;

  EditPopup(this.identifier, this.value, this.controller);
  @override
  _EditPopupState createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${widget.identifier}: ",
                  style: TextStyle(color: Colors.black),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.white),
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
