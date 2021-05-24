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

class SentRequestListScreen extends StatefulWidget {
  @override
  _SentRequestListScreenState createState() => _SentRequestListScreenState();
}

class _SentRequestListScreenState extends State<SentRequestListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RequestProvider>(context, listen: false);

      provider.fetchSentReq();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Received Pictures'),//Text('Sent'),
      ),
      body: Consumer<RequestProvider>(
        builder: (_, provider, __) {
          final res = provider.sendReqRes;

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
                  provider.fetchSentReq();
                },
              );
              break;
          }

          return Container(
            color: Colors.white,
          );
        },
      ),
    );
  }

  Widget buildContainer({List<ResGetAllRequestByReceiverData> data}) {

    if (data == null){
      NoDataFoundSimple(
        text: 'No Pictures Found',
      );
    }

    final provider = Provider.of<RequestProvider>(context);
    return data.length <= 0
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
                    userBadge: res.reciveUserData.badge,
                    type: ImageWidgetType.requestSent,
                    imageURL: res.image == null
                        ? kPlaceHolderBaseUrl
                        : kImgBaseURL + (res.image ?? ''),
                    userURL: (res.reciveUserData.isPrivateProfile == 1) ? "" : kImgBaseURL +
                        (res.reciveUserData.userProfileImage ?? ""),
                    userName: (res.reciveUserData.isPrivateProfile == 1)
                        ? (res.reciveUserData.publicName ?? "Anonymous User")
                        : (res.reciveUserData.firstName ?? "") +
                            " " +
                            (res.reciveUserData.lastName ?? ""),
                    date: res.createdAt.formatDate(),
                    status: 'Status : ${status.getString()}',
                    statusColor: status.getStatusColor(),
                    onTap: () {
                      provider.selectedReceivedReqDetail = res.id;
                      Navigator.of(context)
                          .pushNamed(kRequestDetailSentRoute)
                          .then((value) {
                            if(value != null && value == true){
                              provider.fetchSentReq();
                            }
                      });
                    },
                  );
                }),
          );
  }
}
