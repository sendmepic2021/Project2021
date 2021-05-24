<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Notification;
use App\NotificationShow;
use DB;
use Illuminate\Support\Facades\Validator;
Use Exception;
use Carbon\Carbon;
use Illuminate\Support\Str;
use File;

class NotificationController extends Controller
{
   public function GetAllNotification(){
   try{
         $notifications = Notification::where('screen_id','=',null)->orderBy('notification.id', 'DESC')->get();
         return view('notification.index',compact('notifications'));

    } catch(Exception $exception)
    {  
      return redirect()->route('dashboard')->with('error', 'The error message here!');
    }
   }

  public function CreateNotification(){
    try{
        $users = User::where('user_type',2)->get()->toArray();
      return view('notification.create',compact('users'));

      } catch(Exception $exception)
      {  
        return redirect()->route('dashboard')->with('error', 'The error message here!');
      }
    }


    public function notification_store(Request $request)
    {
        try
        {
                $notification = new Notification;
                $notification->notification_title = $request->notification_title;
                $notification->notification_description = $request->notification_description;
                $notification->notification_type = $request->notification_type;

                if ($request->notification_type == 16)
                {
 
                    $temp_array = implode(",",$request->user_id);

                    $notification->user_id = $temp_array;
                    
                    $us_ids = preg_split("/\,/", $temp_array);
                   
                    $user = DB::table('users')->whereIn('id', $us_ids)->where('is_notification',1)->where('fcm_id', '!=' ,Null)
                    ->get();
                   
                    $user = json_decode( json_encode($user), true);

                    $tokens = [];
                    foreach($user as $key => $values){
                     $tokens[]=$values['fcm_id'];
                    }

                   $notification->save();

                 $notification = Notification::latest('id')->first();
                 foreach($user as $keys => $value){
                  $notification_show = new NotificationShow;
                  $notification_show->user_id = $value['id'];
                  $notification_show->notification_id = $notification['id'];
                  $notification_show->save();
                 }

                 $data = [
                  "notification_id"=>$notification->id
                  ];
                 Notify($request->notification_title,$request->notification_description,$tokens,'default',$data);

                    return redirect()->route('notifications')->with('message', 'Notification Sent successfully!');

                }
                else if ($request->notification_type == 15)
                {
                    $user = DB::table('users')->where('user_type',2)->where('is_notification',1)->where('fcm_id', '!=' ,Null)->get();

                    $user = json_decode( json_encode($user), true);
                    $tokens = [];
                    foreach($user as $key => $values){
                     $tokens[]=$values['fcm_id'];
                    }

                  

                    $notification->save();

                    $notification = Notification::latest('id')->first();
                    foreach($user as $keys => $value){
                     $notification_show = new NotificationShow;
                     $notification_show->user_id = $value['id'];
                     $notification_show->notification_id = $notification['id'];
                     $notification_show->save();
                    }
                    $data = [
                      "notification_id"=>$notification->id
                      ];
                    Notify($request->notification_title,$request->notification_description,$tokens,'default',$data);

                    return redirect()->route('notifications')->with('message', 'Notification Sent successfully!');
           
                }   
        }
        catch(Exception $exception)
        {
          return redirect()->route('dashboard')->with('error', 'The error message here!');
        }
    }


    public function notificationGetById($id){

      if (Notification::where('id', $id)->exists()) {

        $notification = Notification::where('id',$id)->first();
      
        $ids = $notification->user_id;

        $temp_array = explode(",",$ids);
      
    $member="";
    
        $member = User::whereIn('id', $temp_array)->get();

        $notification->member = $member;


       return view('notification.view',compact('notification','member'));
        
        } else {
          return redirect()->route('dashboard')->with('error', 'The error message here!');
         }


    }
}