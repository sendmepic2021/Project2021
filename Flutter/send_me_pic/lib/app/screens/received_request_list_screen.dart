import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/res/res_get_all_request_by_receiver_entity.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';
import 'package:send_me_pic/app/widgets/image_grid_widget.dart';

class ReceivedRequestListPage extends StatefulWidget {
  @override
  _ReceivedRequestListPageState createState() =>
      _ReceivedRequestListPageState();
}

class _ReceivedRequestListPageState extends State<ReceivedRequestListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RequestProvider>(context, listen: false);
      provider.fetchReceivedReq();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sent Pictures'),//Text('Received'),
        ),
        body: Consumer<RequestProvider>(
          builder: (_, provider, __) {
            final res = provider.receivedReqRes;
            print(res.state);
            switch (res.state) {
              case Status.LOADING:
                return LoadingContainer();
                break;
              case Status.COMPLETED:
                // TODO: Handle this case.
                return buildContainer(data: res.data.data);
                break;
              case Status.ERROR:
                return NoDataFoundContainer(
                  title: '',
                  reason: 'No Pictures Found',
                  tryAgainAction: () {
                    provider.fetchReceivedReq();
                  },
                );
                break;
            }

            return Container();
          },
        ));
  }

  Widget buildContainer({List<ResGetAllRequestByReceiverData> data}) {
    final provider = Provider.of<RequestProvider>(context);

    return (data != null && data.length <= 0)
        ? NoDataFoundSimple(
            text: 'No Pictures Found',
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.75),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final res = data[index];
                  final ImageStatus status = ImgStatus.getImgStatus(res.status);
                  return ImageGridWidget(
                    userBadge: res.senderUserData.badge,
                    type: ImageWidgetType.requestSent,
                    imageURL: res.image != null
                        ? kImgBaseURL + res.image
                        : kPlaceHolderBaseUrl,
                    userURL: (res.senderUserData.isPrivateProfile == 1) ? "" : kImgBaseURL +
                        (res.senderUserData.userProfileImage ?? ""),
                    userName: (res.senderUserData.isPrivateProfile == 1)
                        ? (res.senderUserData.publicName ?? "Anonymous User")
                        : (res.senderUserData.firstName ?? "") +
                            " " +
                            (res.senderUserData.lastName ?? ""),
                    date: res.createdAt.formatDate(),
                    status: 'Status : ${status.getString()}',
                    statusColor: status.getStatusColor(),
                    onTap: () {
                      provider.selectedReceivedReqDetail = res.id;
                      Navigator.of(context)
                          .pushNamed(kRequestDetailReceivedRoute);
                    },
                  );
                }),
          );
  }
}
