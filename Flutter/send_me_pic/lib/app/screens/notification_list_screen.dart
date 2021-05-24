import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/res/res_get_notification_by_user.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/providers/service_provider.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ServiceProvider>(context, listen: false);

      provider.fetchNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Consumer<ServiceProvider>(
        builder: (_, provider, __) {
          switch (provider.notificationData.state) {
            case Status.LOADING:
              return LoadingContainer();
              break;
            case Status.COMPLETED:
              return NotificationList(
                data: provider.notificationData.data.data,
              );
              break;
            case Status.ERROR:
              return NoDataFoundContainer(
                title: '',
                  reason: 'No Notifications Found',//provider.notificationData.msg,
                  tryAgainAction: () {
                    provider.fetchNotification();
                  });
              break;
          }

          return Container();
        },
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  NotificationList({this.data});

  final List<NotificationData> data;

  @override
  Widget build(BuildContext context) {
    return data.length <= 0
        ? NoDataFoundSimple(
            text: 'No Notifications Found',
          )
        : buildListView();
  }

  Widget buildListView() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final provider = Provider.of<ServiceProvider>(context, listen: false);
          final res = data[index];
          return Material(
            color: ((data[index].isShowNotification ?? 1) == 1)
                ? Colors.white
                : kPrimaryColor,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.1),
              onTap: () async {
                final reqProvider =
                    Provider.of<RequestProvider>(context, listen: false);

                reqProvider.selectedReceivedReqDetail = res.requestId;

                switch (res.screenId) {
                  case 1:
                    Navigator.of(context).pushNamed(kRequestDetailReceivedRoute);
                    break;
                  case 2:
                    Navigator.of(context)
                        .pushNamed(kRequestDetailSentRoute)
                        .then((value) {
                      if(value != null && value == true){
                        print("cool");
                        provider.fetchNotification();
                      }
                    });
                    break;
                  default:
                    break;
                }

                if (res.isShowNotification != 1) {
                  await reqProvider.updateNotificationStatusById(res.id);

                  final provider =
                      Provider.of<ServiceProvider>(context, listen: false);
                  provider.fetchNotification();
                }
              },
              child: Container(
                // color: ((data[index].isShowNotification ?? 1) == 1) ? Colors.white : Colors.teal.withOpacity(0.1),
                padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  res.notificationTitle ?? "",
                                  style: TextStyle(
                                    color: ((data[index].isShowNotification ?? 1) == 1) ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                                Text(
                                  res.notificationDescription ?? "",
                                  style: TextStyle(
                                    color: ((data[index].isShowNotification ?? 1) == 1) ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                                Text(
                                  formatDate(
                                      myDate: res.createdAt, format: 'hh:mm a'),
                                  style: TextStyle(
                                    color: ((data[index].isShowNotification ?? 1) == 1) ? Colors.grey : Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
