<?php

use Illuminate\Support\Facades\Log;
use Carbon\Carbon;
use App\Logdata;
use App\User;


function statusCode400($message) {
    //1 = Cart method different
        return [
            'data' => array(),
            'status' => 0,
            'message' => $message
        ];
    }

function statusCode401(){
    return [
        'data' => (object)[],
        'status' => 0,
        'message' => "No data found!"
    ];
}

 function getTypeofUser($user_type) {
      if ($user_type == 1) {
          return "Admin";
      }
      if ($user_type == 2) {
          return "User";
      }
  }
  function defaultImage() {
    return url('/') . "/profile.svg";
    // return url('/') . "/no-image.svg";
  }
  function defaultUserImage() {
    return url('/') . "/profile.svg";
  }

function getTypeofLogin($login_type) {
    if ($login_type == 3) {
        return "FaceBook";
    }
    if ($login_type == 4) {
        return "Google";
    }
    if ($login_type == 5) {
        return "Apple";
    }
}

function is_profile($user_type) {
    if ($user_type == 0) {
        return "Public";
    }
    if ($user_type == 1) {
        return "Private";
    }
}


function getTypeofDeviceType($device_type) {
    if ($device_type == 6) {
        return "Android";
    }
    if ($device_type == 7) {
        return "Apple";
    }
    if ($device_type == 8) {
        return "Web";
    }
}


function pre($data){
    echo "<pre>";
    print_r($data);
    echo "</pre>";
    exit;
}

function RequestDataStoreInDB($request){
$log_data = new Logdata;
if($request->header('latitude')){
    $log_data->latitude =$request->header('latitude');
}else{
    $log_data->latitude ="0.00";
}
if($request->header('longitude')){
    $log_data->longitude =$request->header('longitude');
}else{
    $log_data->longitude ="0.00";
}
if($request->header('city')){
    $log_data->city =$request->header('city');
}else{
    $log_data->city ="";
}
if($request->header('isLogin')){
    $log_data->is_login =$request->header('isLogin');
}else{
    $log_data->is_login ="0";
}
if($request->header('userId')){
    $log_data->user_id =$request->header('userId');
}else{
    $log_data->user_id ="0";
}
if($request->header('deviceType')){
    $log_data->device_type =$request->header('deviceType');
}else{
    $log_data->device_type ="";
}
if($request->header('networkType')){
    $log_data->network_type =$request->header('networkType');
}else{
    $log_data->network_type ="";
}
if($request->header('deviceModel')){
    $log_data->device_model =$request->header('deviceModel');
}else{
    $log_data->device_model ="";
}
if($request->header('deviceManufacture')){
    $log_data->device_manufacture =$request->header('deviceManufacture');
}else{
    $log_data->device_manufacture ="";
}
if($request->header('deviceBrand')){
    $log_data->device_brand =$request->header('deviceBrand');
}else{
    $log_data->device_brand ="";
}
if($request->header('deviceSdkVersion')){
    $log_data->device_sdk_version =$request->header('deviceSdkVersion');
}else{
    $log_data->device_sdk_version ="";
}
if($request->header('deviceHost')){
    $log_data->device_host =$request->header('deviceHost');
}else{
    $log_data->device_host ="";
}
if($request->header('appPackage')){
    $log_data->app_package =$request->header('appPackage');
}else{
    $log_data->app_package ="";
}
if($request->header('appVersion')){
    $log_data->app_version =$request->header('appVersion');
}else{
    $log_data->app_version ="";
}
$log_data->req_data =strval($request);
$log_data->save();
}



function Notify($title,$body,$target,$chid,$data)
{

//  define( 'API_ACCESS_KEY', 'AAAAh2SAnv8:APA91bHvnz7HQ7GiuvRtsuggvOKjti-ee3bzgPyj9SbhsnqC-L3h9IYHx27kBdJbjUkKcC_ZThZuqzi57KX31OyK822kVF2DjbxIQd9-3iRRpoTGJX0XMn_kDoGAzhBRz4GppJwRlieQ' );

$fcmMsg = array(
 'title' => $title,
 'body' => $body,
 'channelId' => $chid,
);
$fcmFields = array(
 'registration_ids' => $target, //tokens sending for notification
 'notification' => $fcmMsg,
 'data'=>$data,
);

$headers = array(
 'Authorization: key=' . env('FCM_API_ACCESS_KEY'),
 'Content-Type: application/json'
);

$ch = curl_init();
curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
curl_setopt( $ch,CURLOPT_POST, true );
curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, true );
curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fcmFields ) );
$result = curl_exec($ch );
curl_close( $ch );
// echo $result . "\n\n";

}

function parseDisplayDate($date) {
    return date('d M, Y h:i A', strtotime($date));
}

function parseDisplayDateTime($date) {
    return date('d M, Y ', strtotime($date));
}


function notificationType($type) {
    if ($type == 15) {
        return "All User";
    }
    if ($type == 16) {
        return "Selected User";
    }
}


function UserGetName($id){
    $user = User::where('id',$id)->first('display_name');
    return $user->display_name;
}

function GetNameForNotification($id){
    $user = User::where('id',$id)->first();
    if($user->is_private_profile==1){
        return $user->public_name;
    }else{
        return $user->first_name .' '.$user->last_name;
    }
   
}

function ImageStatus($type){
    $html="";
    $class="";
    if ($type == 11) {
        echo "<span class='badge badge-light-warning' style='padding: 0.25rem 0.45rem;'>Pending</span>";
    }
    if ($type == 12) {
        echo "<span class='badge badge-light-info' style='padding: 0.25rem 0.45rem;'>Confirm</span>";
    }
    if ($type == 13) {
        echo "<span class='badge badge-light-success' style='padding: 0.25rem 0.45rem;'>Completed</span>";
    }
    if ($type == 14) {
        echo "<span class='badge badge-light-danger' style='padding: 0.25rem 0.45rem;'>Rejected</span>";
    }
}

function generateRandomAlphaNum($length) {
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789આવિડિઓમાંતેમેશીખશોકેગુજરાતીકક્કાકખગઘનેઅંગ્રેજીમાંકઈરીતેલખાયછેનાનાબાળકોઅનેજેમનેહમણાંજએંગ્રેજીશીખવાનુંશરૂકર્યુંછેતેમનામાટેઅતિ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
    // return bcrypt($randomString);
}
function getBadge($type){
    if ($type == 18) {
        echo "<span class='badge' style='padding: 0.25rem 0.45rem; color:white; background-color: #144E5A; font-weight: 800;'>Default</span>";
    }
    if ($type == 19) {
        echo "<span class='badge' style='padding: 0.25rem 0.45rem; color:white; background-color: #E38346; font-weight: 800;'>Bronze</span>";
    }
    if ($type == 20) {
        echo "<span class='badge ' style='padding: 0.25rem 0.45rem; color:white; background-color: #868686; font-weight: 800;'>Silver</span>";
    }
    if ($type == 21) {
        echo "<span class='badge ' style='padding: 0.25rem 0.45rem; color:white; background-color: #ffc500; font-weight: 800;'>Gold</span>";
    }
}
function notificationOnOff($id){
    if ($id == 1) {
       return "On";
    }
    if ($id == 0) {
        return "Off";
    }
}
function profileonOnOff($id){
    if ($id == 1) {
       return "Yes";
    }
    if ($id == 0) {
        return "No";
    }
}