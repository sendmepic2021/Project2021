import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';

class EnterDescriptionScreen extends StatefulWidget {
  final Function(String) updateAction;

  const EnterDescriptionScreen({Key key, this.updateAction}) : super(key: key);

  @override
  _EnterDescriptionScreenState createState() => _EnterDescriptionScreenState();
}

class _EnterDescriptionScreenState extends State<EnterDescriptionScreen> {
  TextEditingController _controller;

  // int limit = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Enter Description'),
        actions: [
          // Container(
          //   padding: EdgeInsets.only(right: 10),
          //   child: Center(
          //     child: Text('Text Limit: ${_controller.text.length}/${limit}'),
          //   ),
          // )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: TextField(
                controller: _controller,
                // maxLength: limit,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Insert your message",
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 9999,
                autofocus: true,
              ),
            ),
            if (_controller.text.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      widget.updateAction(_controller.text);
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        'SEND',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
