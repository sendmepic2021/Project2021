import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';

class ImageGridWidget extends StatelessWidget {
  final String imageURL;
  final String userURL;
  final String userName;
  final String date;
  final String status;
  final String statusColor;
  final ImageWidgetType type;
  final VoidCallback onTap;
  final UserBadge userBadge;

  const ImageGridWidget(
      {@required this.type,
      @required this.imageURL,
      @required this.userURL,
      @required this.userName,
      @required this.date,
      this.userBadge,
      this.onTap,
      this.status,
      this.statusColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: kPrimaryColor.withOpacity(0.4),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.grey[300])),
        margin: EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                    color: kPrimaryColor.withOpacity(0.5),
                    child: CustomNetWorkImage(url: imageURL)),
              ),
              if (type == ImageWidgetType.requestReceived)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Request By :',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: userBadge.getStatusColor() ?? kPrimaryColor
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.white,
                            child: CustomNetWorkImage(
                                assetName: 'assets/images/userPlaceHolder.png',
                                url: userURL),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          FittedBox(
                            child: Text(
                              date,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (type != ImageWidgetType.locationProfile)
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: HexColor.fromHex(statusColor).withOpacity(0.8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

enum ImageWidgetType { locationProfile, requestSent, requestReceived }
