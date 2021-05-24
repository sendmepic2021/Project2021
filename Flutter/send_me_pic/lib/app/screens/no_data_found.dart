import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';

class NoDataFoundContainer extends StatelessWidget {

  NoDataFoundContainer({this.title,this.tryAgainAction,String reason}) : reason = reason ?? '';

  final VoidCallback tryAgainAction;

  final String reason;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,//kPrimaryColor,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title ?? 'No Data Found',style: TextStyle(
            color: kPrimaryColor,//Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),),

          SizedBox(height: 10),

          Text(reason,style: TextStyle(
              color: kPrimaryColor,//Colors.white,
              fontSize: 16
          ),
          textAlign: TextAlign.center,),

          SizedBox(height: 10),

          if(tryAgainAction != null)
            Container(
              height: 44,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextButton(
                onPressed: (){
                  if(tryAgainAction != null){
                    tryAgainAction();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Try Again',style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NoDataFoundSimple extends StatelessWidget {

  NoDataFoundSimple({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(text ?? "No Data Found",style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 17,
            letterSpacing: 1
        ),),
      ),
    );
  }
}
