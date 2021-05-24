import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class ImageSelection extends StatefulWidget {
  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   foregroundColor: Colors.white,
      //   backgroundColor: Colors.transparent,
      // ),
      body: buildContainer(),
    );
  }

  Widget buildContainer() {
    final provider = Provider.of<RequestProvider>(context);

    return Container(
      height: double.infinity,
      color: kPrimaryColor,
      child: Stack(
        children: [
          Container(
              height: double.infinity,
              child: Image.file(
                provider.pickedImage,
                fit: BoxFit.fitHeight,
              )),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Consumer<RequestProvider>(
              builder: (_, provider, __) {
                final res = provider.uploadImgRes;

                bool isLoading = false;

                print(res.state);

                switch (res.state) {
                  case Status.LOADING:
                    isLoading = true;
                    break;
                  case Status.COMPLETED:
                    isLoading = false;
                    break;
                  case Status.ERROR:
                    isLoading = false;
                    break;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if(!isLoading)
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: kPinkBTNColor),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.red.withOpacity(0.5)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: kPrimaryColor),
                      child: TextButton(
                        onPressed: () {

                          provider.uploadImage(() {
                            Navigator.pop(context);
                          });
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal.withOpacity(0.5)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ))),
                        child: isLoading
                            ? Container(
                                height: 22,
                                width: 22,
                                child: LoadingSmall(),
                              )
                            : Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
