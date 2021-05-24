<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use DB;
use App\User;
use App\NotificationShow;
use Illuminate\Support\Facades\Validator;
use File;
use Illuminate\Support\Str;
use App\Image;
Use Exception;
use App\Jobs\SendEmailJob;
use Mail;
use Log;


class UsersController extends Controller
{

    private $apiToken;
    public function __construct()
    {
      $this->apiToken = uniqid(base64_encode(str_random(255)));
    }


  public function Login(Request $request){

    // try {

      $user_login = User::where('social_id',$request->social_id)->first();

      if($user_login){

        $validator = Validator::make($request->all(), [
          
          'social_id' => 'required',
          'login_type' => 'required',
      ]);

      if ($validator->fails()) {
          return statusCode400('validation failed.');
      }

        $postArray = ['token' => $this->apiToken,
        'fcm_id'=>$request->fcm_id,
        'login_type'=>$request->login_type,
        'device_type'=>$request->device_type
        ];

       $login = User::where('social_id',$request->social_id)->update($postArray);

       $user = User::where('social_id',$request->social_id)->first();
     
       return response()->json([
        "status"=>1,
        "message" => "Login succesfully.",
        "data"=>$user
       ]);
   
      }
      else{

        $validator = Validator::make($request->all(), [

          'social_id' => 'required|unique:users,social_id',
          'login_type' => 'required',
          'device_type' => 'required',
      ]);

      if ($validator->fails()) {
          return statusCode400('validation failed.');
      }
      else{
         $register = new User;
         $register->first_name = $request->first_name;
         $register->last_name = $request->last_name;
         $register->display_name = $request->first_name;
         $register->user_profile_image = $request->user_profile_image;
         $register->email = $request->email;
         $register->mobile = $request->mobile;
         $register->fcm_id = $request->fcm_id;
         $register->device_type = $request->device_type;
         $register->social_id  = $request->social_id ;
         $register->token = $this->apiToken;
         $register->user_type = 2;
         $register->login_type = $request->login_type;
         $register->user_profile_image = $request->user_profile_image;
         $register->email = $request->email;
         $register->mobile = $request->mobile;
         $register->save();
         
         Log::info(print_r(config('mail.driver'), true));

           Log::info(print_r(config('custom.mail_details'),true));

         SendEmailJob::dispatch($register);
       
         return response()->json([
          "status"=>1,
          "message" => "Register succesfully.",
          "data"=>$register
         ]);
      }
        
      }

    // }
    // catch(Exception $exception)
    // {
    //     return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
    // }
 }
 
 public function UpdateFcmId(Request $request){
   try{
    if (User::where('id', $request->id)->where('user_type',2)->exists())
    {

      $fcmid = User::findOrfail($request->id);
      $fcmid->fcm_id = $request->fcm_id;
      $fcmid->update();

      // $user = User::where('id',$request->id)->first();
      
      return response()->json([
        "status"=>1,
        "message" => "Fcm Id updated",
        "data"=>['id'=>$fcmid->id,'fcm_id'=>$fcmid->fcm_id]
      ]);

    } else
    {
    return statusCode401();   
    }
  
   

     
   }catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
    }

 }


public function GetUserById($id){
 
   try{

    if (User::where('id', $id)->exists())
    {
      
      $user = User::where('id',$id)->first();

      $images="";

      $images = Image::where('receiver_id',$user->id)->where('status',13)->where('is_deleted',0)->get()->toArray();
      $user['profile_total'] = Image::where('receiver_id',$user->id)->count();
      $user['profile_recived'] = Image::where('receiver_id',$user->id)->where('is_deleted',0)->where('status',11)->count();
      $user['profile_completed'] = Image::where('receiver_id',$user->id)->where('is_deleted',0)->where('status',13)->count();

      $user->Image = $images;

      return response()
      ->json(['status' => 1, 'message' => 'Get user by id and all completed images.', 'data' => $user]);
    }
    else
    {
      return statusCode401();   
    }

   }
   catch(Exception $exception)
   {
       return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
   }
}

public function Logout(Request $request){

try{

  if (User::where('id', $request->id)->where('user_type',2)->exists())
    {
   
      $postArray = ['token' => "",'fcm_id'=>null];
      $logout = User::where('id',$request->id)->where('user_type',2)->update($postArray);
      if($logout) {
        return response()->json([
          'status'=>1,
          'message' => 'User Logged Out',
          'data'=>[]
        ]);    
     } 

    }
    else
    {
      return statusCode401();   
    }
    
    }
    catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
    }

  }

  public function IsNotificationActiveInactive(Request $request){

    try{
      if (User::where('id', $request->id)->where('user_type',2)->exists())
      {
    
          $update_notification = User::findOrfail($request->id);  
          $update_notification->is_notification = $request->is_notification;
          $update_notification->update();

          if($request->is_notification == 1){
              return response()->json([
                "status"=>1,
                "message" => "Notification On.",
                "data"=>['id'=>$update_notification->id,'display_name'=>$update_notification->display_name]
            ]);
        
            }elseif($request->is_notification == 0){
              return response()->json([
                "status"=>1,
                "message" => "Notification Off.",
                "data"=>['id'=>$update_notification->id,'display_name'=>$update_notification->display_name]
            ]);
            }
      }
      else
      {
      return statusCode401();   
      }
 }
 catch(Exception $exception)
 {
     return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
 }

  }

  public function IsProfilePrivateActiveInactive(Request $request){

    try{
      if (User::where('id', $request->id)->where('user_type',2)->exists())
      {
    
          $update_private_profile = User::findOrfail($request->id);  
          $update_private_profile->is_private_profile = $request->is_private_profile;
          $update_private_profile->update();

          if($request->is_private_profile == 0){
              return response()->json([
                "status"=>1,
                "message" => "User Profile Public.",
                "data"=>['id'=>$update_private_profile->id,'display_name'=>$update_private_profile->display_name]
            ]);
        
            }elseif($request->is_private_profile == 1){
              return response()->json([
                "status"=>1,
                "message" => "User Profile Private.",
                "data"=>['id'=>$update_private_profile->id,'display_name'=>$update_private_profile->display_name]
            ]);
            }
      }
      else
      {
      return statusCode401();   
      }
    }
    catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
    }

  }

  public function UserUpdateProfileById(Request $request){
    Log::info("calling log". print_r($request->all(), true));
    try{

      if (User::where('id', $request->id)->where('user_type',2)->exists())
      {

        if ($request->hasFile('user_profile_image')) {

          $old_data = User::where('id',$request->id)->first();
  
          $image_path =  public_path('images/'.$old_data->user_profile_image);  // prev image path
  
          if(File::exists($image_path)) {
              File::delete($image_path); 
          }
  
          $filenameoriginal  = $request->file('user_profile_image')->getClientOriginalName();
  
          $destinationPath = public_path('images/users');
  
          $image_name = 'users/User'.'_'.time(). "." . $request->file('user_profile_image')->getClientOriginalExtension();;
                 
          $request->file('user_profile_image')->move($destinationPath,$image_name);
  
          User::where("id",$request->id)->update(array('user_profile_image' =>$image_name));
          }
      
          $user = User::findOrfail($request->id);
          $user->first_name = $request->first_name;
          $user->public_name = $request->public_name;
          $user->last_name = $request->last_name;
          $user->mobile = $request->mobile;
          $user->latitude = $request->latitude;
          $user->longitude = $request->longitude;
          $user->is_private_profile = $request->is_private_profile;
          $user->update();     
      
          $user = User::where('id',$request->id)->first();
      
          return response()->json([
            "status"=>1,
            "message" => "user record updated",
            "data"=>$user
        ]);

      }
      else
      {
      return statusCode401();   
      }

    }catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
    }

  }

  public function getUserAndImageByLatLong(Request $request){
    try{

      if (true)
      {
        $radiusKM = 10;
        $images = Image::selectRaw("*,
        ( 6371  * acos( cos( radians(?) ) *
          cos( radians( latitude ) )
          * cos( radians( longitude ) - radians(?)
          ) + sin( radians(?) ) *
          sin( radians( latitude ) ) )
        ) AS distance", [$request->latitude, $request->longitude, $request->latitude])
            ->having("distance", "<", $radiusKM)
            ->orderBy("distance",'asc')
            ->where('is_deleted',0)
            ->offset(0)
            ->limit(20)
            ->where('image_place_name', 'like', '%'.$request->search_text.'%')
            ->get()->toArray();

            foreach($images as $key => $value){
                
              $send_user_data = User::where('id',$value['sender_id'])->first()->toArray(); 
              $recive_user_data = User::where('id',$value['receiver_id'])->first()->toArray();
             
              $images[$key]['sender_user_data'] = $send_user_data;
              $images[$key]['recive_user_data'] = $recive_user_data;
          
          }


            
          $data['user_list'] = User::selectRaw("*,
        ( 6371  * acos( cos( radians(?) ) *
          cos( radians( latitude ) )
          * cos( radians( longitude ) - radians(?)
          ) + sin( radians(?) ) *
          sin( radians( latitude ) ) )
        ) AS distance", [$request->latitude, $request->longitude, $request->latitude])
        ->whereNotIn('id', [$request->user_id])
            ->having("distance", "<", $radiusKM)
            ->orderBy("distance",'asc')
            ->offset(0)
            ->limit(20)
            ->where('token','!=',"")
            ->where('user_type',2)
            ->where(function ($query) use ($request) {
              $query
              ->where('first_name', 'like', '%'.$request->search_text.'%')
              ->orWhere('last_name', 'like', '%'.$request->search_text.'%')
              ->orWhere('public_name', 'like', '%'.$request->search_text.'%');
              })
              ->get()->toArray();


        foreach ($images as $key => $item) {
          $images[$key]['latlong'] = ''.substr($item['latitude'], 0, 5).','.substr($item['longitude'], 0, 5);
        }

        $collection = collect($images);

        $groupedByValue = $collection->groupBy('latlong');

   
        $temp_data = [];

        foreach ($groupedByValue as $key => $item) {
         array_push($temp_data,$item);
        }

        $data['image_group'] = $temp_data;

        return response()->json([
          "status"=>1,
          "message" => "User details by Lat-Long",
          "data"=>$data
      ]);
  
      }
      else
      {
        return [
          'status' => 0,
          'message' => "No data found!",
          'data' => []
      ];    
      }

    }catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => $exception, "data" => []]);
    }

  }

  public function updateUserLocation(Request $request){

    if (User::where('id', $request->id)->where('user_type',2)->exists())
    {
      $update_loc = User::findOrfail($request->id);  
      $update_loc->latitude = $request->latitude;
      $update_loc->longitude = $request->longitude;
      $update_loc->palace_name = $request->palace_name;
      $update_loc->update();

      return [
        'status' => 1,
        'message' => "Update user location!",
        'data' => $update_loc
    ];    
    }
      else
      {
        return statusCode401();   
      }
  }

  public function getDashboardCount(Request $request){
    try{
    $sender_req_count = Image::where('sender_id',$request->user_id)->where('is_deleted',0)->where('is_sender_show',0)->count();

    $receiver_req_count = Image::where('receiver_id',$request->user_id)->where('is_deleted',0)->where('is_receiver_show',0)->count();
    
    $user_notification_count = NotificationShow::where('user_id',$request->user_id)
                                          ->where('is_show_notification',0)->where('is_deleted',0)->count();
        $data['send_req_count']  = $sender_req_count;
        $data['receive_req_count']  = $receiver_req_count;                                
        $data['user_notification_count']  = $user_notification_count;

        return [
          'status' => 1,
          'message' => "Dashboard count!",
          'data' => $data
        ];   
      }catch(Exception $exception)
      {
          return response()->json(["status" => 0, "message" => $exception, "data" => (object)[]]);
      }
  }

}
