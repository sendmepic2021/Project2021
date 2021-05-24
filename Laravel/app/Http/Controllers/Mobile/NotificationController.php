<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use DB;
use App\User;
use App\NotificationShow;
use App\Notification;
use Illuminate\Support\Facades\Validator;
use File;
use Illuminate\Support\Str;
use App\Image;
Use Exception;

class NotificationController extends Controller
{
    public function get_notification_by_id(Request $request,$id){

        try{

            if (Notification::where('id', $id)->exists()) {

                $notification = Notification::where('id',$id)->first();
        
                $ids = $notification->user_id;
                
                $temp_array = explode(",",$ids);
        
                $user="";
        
                $user = User::whereIn('id', $temp_array)->get(['display_name','id']);
        
                if($notification->notification_type == 15){
                    
                    $notification['type_title'] = "All user";
        
                }else{
        
                $notification['type_title'] = "Multiple user";
        
                }
        
                $notification->User = $user;
        
                return response()->json 
                    (["status" => 1, 
                    "message" => "notification data by id", 
                    "data" => $notification]);
                
                } else {
                    $empty = (object)[];
                   return response()->json([
                       "status"=>0,
                       "message"=> "No data found!",
                       "data"=>$empty
                       
                   ]);
                 }       
                  
        }catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => $exception, "data" => []]);
        }
       
       
    }
    public function getNotificationUserById($id){

        if (NotificationShow::where('user_id', $id)->exists()) {

        // $usr_noti =  Notification::where('user_id', 'like', '%' . $id . '%')
        // ->orWhere('user_id', 'like',  $id . '%')
        // ->orWhere('user_id', 'like', '%'.  $id )
        // ->orWhere('user_id',  $id )
        // ->orWhere('user_id',  [])
        // ->get()
        // ->toArray();
     $usr_noti = NotificationShow::where('tbl_notification_show.user_id',$id)
            ->where('tbl_notification_show.is_deleted',0)
            ->leftjoin('notification','tbl_notification_show.notification_id','=','notification.id')
             ->orderBy('notification.id', 'DESC')
            ->select('notification.*','tbl_notification_show.is_show_notification')
            ->get();

    //  $usr_noti = DB::table('tbl_notification_show')
    //             ->where('tbl_notification_show.user_id',$id)
    //             ->where('tbl_notification_show.is_deleted',0)
    //             ->leftjoin('notification','tbl_notification_show.notification_id','=','notification.id')
    //              ->orderBy('notification.id', 'DESC')
    //             ->select('notification.*','tbl_notification_show.is_show_notification')
    //             ->get();
        
        return response()->json 
        (["status" => 1, 
        "message" => "User get notification.", 
        "data" => $usr_noti]);

    } else {
       return response()->json([
           "status"=>0,
           "message"=> "No data found!",
           "data"=>[]
       ]);

    }
  }


  public function updateNotificationStatusById(Request $request){
    try{

        if (NotificationShow::where('user_id',$request->user_id)
        ->where('notification_id',$request->notification_id)->exists()) {
         $update_status_notification = NotificationShow::where('user_id',$request->user_id)
        ->where('notification_id',$request->notification_id)
        ->update(['is_show_notification' => 1]);

         $update_status_notification = NotificationShow::where('user_id',$request->user_id)
         ->where('notification_id',$request->notification_id)->first();

        return response()->json 
        (["status" => 1, 
        "message" => "User show notification, status update.", 
        "data" => $update_status_notification]);
    } else {
        return response()->json([
            "status"=>0,
            "message"=> "No data found!",
            "data"=>(object)[]
        ]);
          }
          
    }catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => $exception, "data" => (object)[]]);
    }
  }

  public function showAllNotificationByUserId(Request $request){
    try{
        if (NotificationShow::where('user_id',$request->user_id)->exists()) {

            $show_all_notification = NotificationShow::whereIn('user_id',[$request->user_id])
                                                      ->update(['is_show_notification' => 1]);

                                return response()->json 
                                (["status" => 1, 
                                "message" => "User show all notification, status update.", 
                                "data" => $show_all_notification]);

        } else {
            return response()->json([
                "status"=>0,
                "message"=> "No data found!",
                "data"=>(object)[]
            ]);
              }



    }catch(Exception $exception)
    {
        return response()->json(["status" => 0, "message" => $exception, "data" => (object)[]]);
    }

  }

}