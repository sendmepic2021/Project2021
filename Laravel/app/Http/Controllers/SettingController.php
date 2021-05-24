<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\AppSetting;
use App\WebSettings;
use DB;
use config;
use Log;
use Illuminate\Support\Facades\Validator;
Use Exception;
use Carbon\Carbon;
use Illuminate\Support\Str;
use File;

class SettingController extends Controller
{
    public function AppSettings(Request $request){
       
         $appsettings = AppSetting::first();

         return view('settings.appsetting',compact('appsettings'));
          
    }

    public function UpdateAppSettings(Request $request,$id){

         if (AppSetting::where('id', $id)->exists()) {

        $appsetting = AppSetting::findOrfail($id);

        $appsetting->android_app_version = $request->android_app_version;
        $appsetting->ios_app_version = $request->ios_app_version;
        $appsetting->image_base_url = $request->image_base_url;
        $appsetting->base_url = $request->base_url;
        $appsetting->is_undermaintenance = $request->is_undermaintenance;
        $appsetting->default_request_limit = $request->default_request_limit;
        $appsetting->term_and_condition = htmlspecialchars_decode($request->term_and_condition);
        $appsetting->policy = htmlspecialchars_decode($request->policy);
        $appsetting->about_us = htmlspecialchars_decode($request->about_us);
        $appsetting->update();

        return redirect()->route('appsettings')->with('message', 'Update Application Settings successfully!');

         }
        else {
          return redirect()->route('dashboard')->with('error', 'User not found!');
          }
    }

    public function WebSettings(){
 
        $websetting = WebSettings::first();

        return view('settings.websetting',compact('websetting'));
    }

    public function UpdateWebSettings(Request $request,$id){

        if (WebSettings::where('id', $id)->exists()) {

       $websetting = WebSettings::findOrfail($id);

       $websetting->default_email = $request->default_email;
       $websetting->email_protocol = $request->email_protocol;
       $websetting->smtp_port = $request->smtp_port;
       $websetting->smtp_crypto = $request->smtp_crypto;
       $websetting->smtp_host = $request->smtp_host;
       $websetting->smtp_user = $request->smtp_user;
       $websetting->smtp_password = $request->smtp_password;
       $websetting->from_name = $request->from_name;
       $websetting->update();

       $mail_details = [
        'MAIL_MAILER'=>$websetting->email_protocol,
        'MAIL_HOST'=>$websetting->smtp_host,
        'MAIL_PORT'=>$websetting->smtp_port,
        'MAIL_USERNAME'=>$websetting->smtp_user,
        'MAIL_PASSWORD'=>$websetting->smtp_password,
        'MAIL_ENCRYPTION'=>$websetting->smtp_crypto,
        'MAIL_FROM_ADDRESS'=>$websetting->smtp_user,
        'MAIL_FROM_NAME'=>$websetting->from_name,
      ];

      // config('custom.mail_details.MAIL_HOST', $request->smtp_host);

         config(['custom.mail_details' =>  $mail_details]);

      // Log::info(print_r(config('custom.mail_details'),true));
      
      return redirect()->route('websetting')->with('message', 'Update Web Settings successfully!');

        }
       else {
         return redirect()->route('dashboard')->with('error', 'User not found!');
         }
   }
}
