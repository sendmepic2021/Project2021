<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use DB;
use App\User;
use App\Notification;
use App\NotificationShow;
use Illuminate\Support\Facades\Validator;
use File;
use Illuminate\Support\Str;
use App\Image;
Use Exception;
Use Log;

class ImageController extends Controller
{
    public function SendRequestApiForImage(Request $request){

        try{

            $validator = Validator::make($request->all(), [

                'description' => 'required',
                'sender_id' => 'required',
                'receiver_id' => 'required'
            ]);
      
            if ($validator->fails()) {
                return statusCode400('validation failed.');
            }
            else{
                $send_req = new Image;
                $send_req->description = $request->description;
                $send_req->sender_id = $request->sender_id;
                $send_req->receiver_id = $request->receiver_id;
                $send_req->is_sender_show = 1;
                $send_req->status = 11;
                $send_req->save();
                
                $send_req = Image::latest('id')->first();

                //Send Notification
                $token = DB::table('users')->select('users.fcm_id')->where('id',$send_req->receiver_id)->where('is_notification',1)->where('user_type',2)->where('fcm_id', '!=' ,Null)->get();
                $token = json_decode( json_encode($token), true);
                    $tokens = [];
                    foreach($token as $key => $values){
                     $tokens[]=$values['fcm_id'];
                    }

                $title = GetNameForNotification($send_req->sender_id). ' request to ' .GetNameForNotification($send_req->receiver_id);
              
                $body = $send_req->description;
              
              
             // notification table entry
               $notification = new Notification;
               $notification->notification_title = $title;
               $notification->notification_description = $send_req->description;
               $notification->notification_type = 15;
               $notification->	screen_id = 1;
               $notification->request_id =$send_req->id;
               $notification->user_id = $send_req->receiver_id;
               $notification->save();
            // notification table latest entry
               $notification = Notification::latest('id')->first();
            // show notification table entry
               $notification_show = new NotificationShow;
               $notification_show->user_id = $send_req->receiver_id;
               $notification_show->notification_id = $notification->id;
               $notification_show->save();

               //notification sent

               $data = [
                "notification_id"=>$notification->id,
                "request_id"=>$send_req->id,
                "screen_id" => 1
                ];
     

           Notify($title,$body,$tokens,'default',$data);
       
                return response()->json([
                "status"=>1,
                "message" => "Image Request sent successfully.",
                "data"=>$send_req
                ]);
            }


        } catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
        }
       
    }

    public function GetAllRequestSenderId($id){
        try{
             if (Image::where('sender_id', $id)->exists()) {

              $sender_image = Image::where('sender_id',$id)->orderBy('created_at', 'DESC')->where('image.is_deleted',0)->get()->toArray();

           $data =[];

            foreach($sender_image as $key => $value){
                
                $send_user_data = User::where('id',$value['sender_id'])->first()->toArray(); 
                $recive_user_data = User::where('id',$value['receiver_id'])->first()->toArray();
               
                $sender_image[$key]['sender_user_data'] = $send_user_data;
                $sender_image[$key]['recive_user_data'] = $recive_user_data;
            
            }
              
            $data = $sender_image;           
              
              return response()->json([
                "status"=>1,
                "message" => "Get all Request by sender user.",
                "data"=>$sender_image
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
        }
        catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
        }
    }
    //
    public function GetRequestDetailById($id,Request $request){

        try{
            if (Image::where('id', $id)->exists())
            {
             $image_detail = Image::where('id',$id)->first();

             $sender_user_data = User::where('id',$image_detail->sender_id)->first();

             $sender = Image::where('id',$id)->where('sender_id',$request->user_id)->update(['is_sender_show'=>1]);

             $recive_user_data = User::where('id',$image_detail->receiver_id)->first();

             $sender = Image::where('id',$id)->where('receiver_id',$request->user_id)->update(['is_receiver_show'=>1]);

             $noti = Notification::where('request_id',$id)->where('user_id',$request->user_id)->first();

             $is_noti = NotificationShow::where('notification_id',$noti->id)->where('user_id',$request->user_id)->update(['is_show_notification'=>1]);
             
             $image_detail['sender_user_data'] = $sender_user_data;
             $image_detail['recive_user_data'] = $recive_user_data;

             return response()->json([
               "status"=>1,
               "message" => "Get Request Details by id.",
               "data"=>$image_detail
               ]);
            }
            else
            {
            return statusCode401();   
            }
       }
       catch(Exception $exception)
       {
           return response()->json(["status" => 0, "message" => $exception, "data" => []]);
       }
        
    }

    public function GetAllRequestReceviverId($id){
        try{
             if (Image::where('receiver_id', $id)->exists())
             {
           
              $receiver_image = Image::where('receiver_id',$id)->orderBy('created_at', 'DESC')->where('image.is_deleted',0)->get()->toArray(); 

              $data =[];

              foreach($receiver_image as $key => $value){
                  
                  $send_user_data = User::where('id',$value['sender_id'])->first()->toArray(); 
                  $recive_user_data = User::where('id',$value['receiver_id'])->first()->toArray();
                 
                  $receiver_image[$key]['sender_user_data'] = $send_user_data;
                  $receiver_image[$key]['recive_user_data'] = $recive_user_data;
              
              }
                
              $data = $receiver_image;       

              return response()->json([
                "status"=>1,
                "message" => "Get all Request by receiver user.",
                "data"=>$receiver_image
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
        }
        catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
        }
    }

    public function UpdateStatusOfRequestId(Request $request){
     
       
        try{
            if (Image::where('id', $request->id)->exists())
            {
          
                $update_status = Image::findOrfail($request->id);  
                $update_status->status = $request->status;
                if($request->status == 14){
                    $update_status->is_sender_show = 0;
                }
                  $update_status->update();

                 //Send Notification
                 $image_req = Image::where('id',$request->id)->first();

                 $token = DB::table('users')->select('users.fcm_id')->where('id',$image_req->sender_id)->where('user_type',2)->where('is_notification',1)->where('fcm_id', '!=' ,Null)->get();

                 $token = json_decode( json_encode($token), true);
                     $tokens = [];
                     foreach($token as $key => $values){
                      $tokens[]=$values['fcm_id'];
                     }

                     if($request->status == 12){
                        $title = GetNameForNotification($image_req->receiver_id). ' accept your request.';
                     }elseif($request->status == 14){
                        $title = GetNameForNotification($image_req->receiver_id). ' reject your request.';
                     }
                 
                 $body = $image_req->description;
               
               
            // notification table entry
                $notification = new Notification;
                $notification->notification_title = $title;
                $notification->notification_description = $image_req->description;
                $notification->notification_type = 15;
                $notification->	screen_id = 2;
                $notification->request_id = $request->id;
                $notification->user_id = $image_req->sender_id;
                $notification->save();

                 // notification table latest entry get
               $notification = Notification::latest('id')->first();
               // show notification table entry
                  $notification_show = new NotificationShow;
                  $notification_show->user_id = $image_req->sender_id;
                  $notification_show->notification_id = $notification->id;
                  $notification_show->save();

                  $data = [
                    "notification_id"=>$notification->id,
                    "request_id"=>$request->id,
                    "screen_id" => 2
                    ];
         

               Notify($title,$body,$tokens,'default',$data);

                if($request->status == 12){
                    return response()->json([
                      "status"=>1,
                      "message" => "Confirm image request.",
                      "data"=>['image-id'=>$update_status->id,'receiver-id'=>$update_status->receiver_id]
                  ]);
              
                  }elseif($request->status == 14){
                    return response()->json([
                      "status"=>1,
                      "message" => "Rejecte image request.",
                      "data"=>['image-id'=>$update_status->id,'receiver-id'=>$update_status->receiver_id]
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

    public function UploadImageOfRequestId(Request $request){
       
        try{
            if (Image::where('id', $request->id)->exists())
            {

             $status_check =  Image::where('id', $request->id)->first();
                if($status_check->status == "13"){
                    return response()->json([
                        "status"=>0,
                        "message" => "Job already completed",
                        "data"=>(object)[]
                    ]);
                }else{

                if ($request->hasFile('image')) {
                   
                    $old_data = image::where('id',$request->id)->first();
    
                    $image_path =  public_path('images/'.$old_data->image);  // prev image path
    
                    if(File::exists($image_path)) {
                        File::delete($image_path); 
                    }
    
                    $filenameoriginal  = $request->file('image')->getClientOriginalName();

                    $destinationPath = public_path('images/upload-image');

                    $image_name = 'upload-image/Upload-image'.'_'.time(). "." . $request->file('image')->getClientOriginalExtension();
                           
                    $request->file('image')->move($destinationPath,$image_name);
    
                    image::where("id",$request->id)->update(array('image' =>$image_name,'status'=>13,
                'latitude'=>$request->latitude,'longitude'=>$request->longitude,'image_place_name'=> $request->image_place_name,'is_sender_show'=>0));
        
                 //Send Notification
                 $image_req = Image::where('id',$request->id)->first();
    
                 $token = DB::table('users')->where('id',$image_req->sender_id)->where('is_notification',1)->where('user_type',2)->where('fcm_id', '!=' ,Null)->get();

                 $token = json_decode( json_encode($token), true);
                     $tokens = [];
                     foreach($token as $key => $values){
                      $tokens[]=$values['fcm_id'];
                     }
                    //  pre($token);
                 $title = GetNameForNotification($image_req->receiver_id). ' has job completed.';
                 $body = $image_req->description;
               

                 //Update level
                 $count = Image::where('receiver_id',$request->id)->where('status',13)->count();
                 if($count >= 100 && $count < 500){
                    User::where("id",$request->id)->update(array('level_id' => 19));
                 }else if($count >= 500 && $count < 1000){
                    User::where("id",$request->id)->update(array('level_id' => 20));
                 }else if($count >= 1000){
                    User::where("id",$request->id)->update(array('level_id' => 21));
                 }

                //  $count = Image::where('receiver_id',$image_req->receiver_id)->where('status',13)->count();
                //  if($count >= 2 && $count < 5){
                //     User::where("id",$image_req->receiver_id)->update(array('level_id' => 19));
                //  }else if($count >= 5 && $count < 8){
                //     User::where("id",$image_req->receiver_id)->update(array('level_id' => 20));
                //  }else if($count >= 8){
                //     User::where("id",$image_req->receiver_id)->update(array('level_id' => 21));
                //  }
  

               $notification = new Notification;    
               $notification->notification_title = $title;
               $notification->notification_description = $image_req->description;
               $notification->notification_type = 15;
               $notification->	screen_id = 2;
               $notification->request_id = $request->id;
               $notification->user_id = $image_req->sender_id;
               $notification->save();

                    // notification table latest entry get
                    $notification = Notification::latest('id')->first();
                    // show notification table entry
                       $notification_show = new NotificationShow;
                       $notification_show->user_id = $image_req->sender_id;
                       $notification_show->notification_id = $notification->id;
                       $notification_show->save();

                  $data = [
                    "notification_id"=>$notification->id,
                     "request_id"=>$request->id,
                     "screen_id" => 2
                     ];

               Notify($title,$body,$tokens,'default',$data);

                $up_image = Image::where('id',$request->id)->first(['id','image','sender_id','latitude','longitude','image_place_name']);
                return response()->json([
                    "status"=>1,
                    "message" => "Image upload done",
                    "data"=>$up_image
                ]);
               }
               else{
                return response()->json([
                    "status"=>0,
                    "message" => "Please select image.",
                    "data"=>(object)[]
                ]);
               }
            }
        }
            else
            {
            return statusCode401();   
            }
       }
       catch(Exception $exception)
       {
           return response()->json(["status" => 0, "message" =>  $exception, "data" => (object)[]]);
       }

    }

    public function GetCenterFromDegreesByLatLong(Request $request){
    // $lat = 23.038439;
    // $lng = 72.634869;
    
    // $url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.trim($lat).','.trim($lng).'&key='.env( 'GOOGLE_MAPS_KEY' );
    // $json = @file_get_contents($url);
    // $data=json_decode($json);
    // $status = $data->status;
    // if($status=="OK")
    // {
    //   return $data->results;
    // }
    // else
    // {
    //   return false;
    // }

    // return $url;

    // $data = Image::where('latitude',$request->latitude)->where('longitude',$request->longitude)->get()->toArray();

    try{

        $data = Image::get(['latitude','longitude'])->toArray();

        if (!is_array($data)) return FALSE;
    
        $num_coords = count($data);
    
        $X = 0.0;
        $Y = 0.0;
        $Z = 0.0;
    
        foreach ($data as $coord)
        {
            // dd($coord);
            $lat = $coord['latitude'] * pi() / 180;
            $lon = $coord['longitude'] * pi() / 180;
    
            $a = cos($lat) * cos($lon);
            $b = cos($lat) * sin($lon);
            $c = sin($lat);
    
            $X += $a;
            $Y += $b;
            $Z += $c;
        }
    
        $X /= $num_coords;
        $Y /= $num_coords;
        $Z /= $num_coords;
    
        $lon = atan2($Y, $X);
        $hyp = sqrt($X * $X + $Y * $Y);
        $lat = atan2($Z, $hyp);
    
        // return array($lat * 180 / pi(), $lon * 180 / pi());
        return response()->json(["status" => 1, "message" => "This is center", "data" => ['latitude'=>$lat * 180 / pi(),'longitude'=> $lon * 180 / pi()]]);

    } catch(Exception $exception)
       {
           return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
       }
 
  }

  
  public function culsterUserByLatLong(Request $request){

      $culsterUsers = DB::select('CALL `ClusterUseToFilterUsers`()');

      $culsterUsers = json_decode( json_encode($culsterUsers), true);

//    pre($culsterUsers);

      return response()->json([
        "status"=>1,
        "message" => "All images groupBy lat-long.",
        "data"=>$culsterUsers
        ]);
   }

    public function imageArrayGetDetails(Request $request){


        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            return statusCode400('validation failed.');
        }
        $temp_array = preg_split("/\,/", $request->id);

        if (Image::whereIn('id',$temp_array)->exists()) { 

            $image_detail = Image::whereIn('id',$temp_array)->get()->toArray();

            $data =[];
    
            foreach($image_detail as $key => $value){
                
                $send_user_data = User::where('id',$value['sender_id'])->first()->toArray(); 
                $recive_user_data = User::where('id',$value['receiver_id'])->first()->toArray();
               
                $image_detail[$key]['sender_user_data'] = $send_user_data;
                $image_detail[$key]['recive_user_data'] = $recive_user_data;
            
            }
    
            $data = $image_detail;    
            return response()->json([
                "status"=>1,
                "message" => "Image array details.",
                "data"=>$data
                ]);


        }else{
            return [
                'status' => 0,
                'message' => "No data found!",
                'data' => []
            ];  
          }

    }

    public function byLatLongSearchKey(Request $request){

  
        $radius = 1;
        // $latitude = 23.052427517590434 ;
        // $longitude = 72.66440798151443;
        

        $image = Image::selectRaw("*,
                         ( 6371  * acos( cos( radians(?) ) *
                           cos( radians( latitude ) )
                           * cos( radians( longitude ) - radians(?)
                           ) + sin( radians(?) ) *
                           sin( radians( latitude ) ) )
                         ) AS distance", [$request->latitude, $request->longitude, $request->latitude])
            ->having("distance", "<", $radius)
            ->orderBy("distance",'asc')
            ->offset(0)
            ->limit(20)
            ->where('image_place_name', 'like', '%'.$request->name.'%')
            ->get()->toArray();

            
            if($image == []){
                return response()->json([
                    "status"=>1,
                    "message" => "No data available.",
                    "data"=>[]
                    ]);
            }else{
                return response()->json([
                    "status"=>1,
                    "message" => "Your search result here.",
                    "data"=>$image
                    ]);
            }
      }

      public function sendMultipleRequestToimage(Request $request){

        $us_ids = preg_split("/\,/", $request->receiver_id);

        foreach($us_ids as $key=>$value){
            // pre($value);
            $send_req = new Image;
            $send_req->description = $request->description;
            $send_req->sender_id = $request->sender_id;
            $send_req->receiver_id = $value;
            $send_req->is_sender_show = 1;
            $send_req->status = 11;
            $send_req->save();

            $image_latest_req = Image::latest('id')->first();


            //   //Send Notification
              $token = DB::table('users')->select('users.fcm_id')->where('id',$image_latest_req ->receiver_id)->where('is_notification',1)->where('user_type',2)->where('fcm_id', '!=' ,Null)->get();
              $token = json_decode( json_encode($token), true);

                  $tokens = [];
                  foreach($token as $key => $values){
                   $tokens[]=$values['fcm_id'];
                  }

              $title = GetNameForNotification($image_latest_req->sender_id). ' request to ' .GetNameForNotification($image_latest_req->receiver_id);
              
              $body = $image_latest_req->description;
           

          // NOtification table entry

            $notification = new Notification;
            $notification->notification_title = $title;
            $notification->notification_description = $body;
            $notification->	screen_id = 1;
            $notification->request_id =$image_latest_req->id;
            $notification->notification_type = 15;
            $notification->user_id = $value;
            $notification->save();


            $notification_latest = Notification::latest('id')->first();
       
             $notification_show = new NotificationShow;
             $notification_show->user_id = $notification_latest->user_id;
             $notification_show->notification_id = $notification_latest->id;
             $notification_show->save();

              
             $data = [
                "notification_id"=>$notification_latest->id,
                "request_id"=>$send_req->id,
                "screen_id" => 1
                ];
     
          Notify($title,$body,$tokens,'default',$data);
           
        }
       
        return response()->json([
            "status"=>1,
            "message" => "Image multiple request sent successfully.",
            "data"=>(object)[]
            ]);
      }

      public function deleteImage(Request $request){

        if (Image::where('id', $request->id)->exists())
        {

            $old_data = Image::where('id',$request->id)->first();
  
            $image_path =  public_path('images/'.$old_data->image);  // prev image path
    
            if(File::exists($image_path)) {
                File::delete($image_path); 
            }
            $old_data->is_deleted = 1;
            $old_data->update();

            $notification_array = Notification::whereIn('request_id',[$request->id])->get();
           
            foreach($notification_array as $key => $value){

             $show_notification = NotificationShow::where('notification_id',$value['id'])->update(['is_deleted'=>1]);
      
            }

            return response()->json([
                "status"=>1,
                "message" => "Image deleted successfully.",
                "data"=>(object)[]
                ]);
        }
        else
        {
        return statusCode401();   
        }
      }

      public function showSentRequest(Request $request){
          $user_id = $request->user_id;
        if (Image::where('sender_id', $user_id)->exists())
        {
            $show_sent_request = Image::whereIn('sender_id',[$user_id])->update(array('is_sender_show' => 1));
            return response()->json([
                "status"=>1,
                "message" => "Image show successfully.",
                "data"=>(object)[]
                ]);
        }
        else
        {
        return statusCode401();   
        }
      }

      public function showReceiveRequest(Request $request){
        $user_id = $request->user_id;
      if (Image::where('receiver_id', $user_id)->exists())
      {
          $show_receive_request = Image::whereIn('receiver_id',[$user_id])->update(array('is_receiver_show' => 1));
          return response()->json([
              "status"=>1,
              "message" => "Image show successfully.",
              "data"=>(object)[]
              ]);
      }
      else
      {
      return statusCode401();   
      }
    }
  
}
