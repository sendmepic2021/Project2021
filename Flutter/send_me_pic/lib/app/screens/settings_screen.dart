import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/providers/settings_provider.dart';
import 'package:send_me_pic/app/screens/cms_screen.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:rate_my_app/rate_my_app.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _isNotificationOn = false;

  bool isLoading = false;

  int selectedIndex = 0;

  void invitePeople() async {
    final RenderBox box = context.findRenderObject();

    Share.share('Ask for a pic and See the world live, \n ' + kApplicationUrl,subject: 'Send Me Pic',sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.sqt.send_me_pic',
    appStoreIdentifier: '1564025954',
  );

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  Future getLocalData() async{

    var local = await UserPreferences().getUser();

    setState(() {
      _isNotificationOn = local.isNotificationOn == 1;
    });

  }

  Future getCMSPages(int id) async {

    CMSType type = CMSType.aboutUs;

    switch(id){
      case 1:
        type = CMSType.terms;
        break;
      case 2:
        type = CMSType.privacyPolicy;
        break;
      case 3:
        type = CMSType.aboutUs;
        break;
      default:
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      final settingProvider = Provider.of<SettingsProvider>(context,listen: false);

      settingProvider.fetchCMSContent(id: id,completion: (res){

        if(res.state == Status.COMPLETED){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CMSScreen(type: type)));
        }

      });
    });
  }

  Widget _listObject(int index, BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final settingProvider = Provider.of<SettingsProvider>(context,listen: false);
    return ListTile(
      onTap: (){
        selectedIndex = index;
        switch(index){
          case 0:
            setState(() {
              _isNotificationOn = !_isNotificationOn;
              settingProvider.setNotificationClicked(_isNotificationOn);
            });
            break;
          case 1:
            getCMSPages(2);
          break;
          case 2:
            getCMSPages(1);
            break;
          case 3:
            getCMSPages(3);
            break;
          case 4:
            invitePeople();
            break;
          case 5:
            rateMyApp .showRateDialog(context);

            break;
          case 6:
            CustomPopup(context,title: 'Logout',message: 'Are you sure you want to logout ?',primaryBtnTxt: 'YES',secondaryBtnTxt: 'NO',primaryAction: () async {
              await auth.logOutUser();
              Navigator.pushNamedAndRemoveUntil(context, kInitialRoute, (r) => false);
            });
            break;
          default: break;
        }

      },
      title: Consumer<SettingsProvider>(
        builder: (_, provider, __) {

          if(provider.cmsData != null){
            switch(provider.cmsData.state){
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
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settingProvider.listNames[index],
                    style: TextStyle(fontSize: 16),
                  ),
                  if (index == 0)
                    Switch(
                      value: _isNotificationOn,
                      onChanged: (isOn){
                        settingProvider.setNotificationClicked(isOn);
                        setState(() {
                          _isNotificationOn = isOn;
                        });
                      },
                      activeColor: kPrimaryColor,
                    )
                  else
                    Container(
                      child: (isLoading && selectedIndex == index) ? LoadingSmall(color: kPrimaryColor,size: 10,) : Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.black,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1,
                color: Colors.grey[300],
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: settingProvider.listNames.length,
            itemBuilder: (context, index) => _listObject(index, context)),
      ),
    );
  }
}
