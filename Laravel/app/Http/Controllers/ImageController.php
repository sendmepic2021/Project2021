<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Image;
use App\Notification;
use App\NotificationShow;
use DB;
use Illuminate\Support\Facades\Validator;
Use Exception;
use Carbon\Carbon;
use Illuminate\Support\Str;
use File;
use Log;

class ImageController extends Controller
{
    public function SearchGetAllImages(Request $request){


         $latlongs = DB::table("image")
         ->where('image.is_deleted',0)
        ->select("image.id","image.sender_id","image.receiver_id","image.image","image.created_at","image.status" )
        ->get()
        ->toArray();

        $latlongs = json_decode( json_encode($latlongs), true);

        return view('photo.photo',compact('latlongs'));

    }

    public function filterStatus1($id){
        
        try{

            // $result = Image::where('status', $id)->get()->toArray();
            
            $result =  DB::table("image");
            if($id != 'all'){
                $result = $result->where('image.status','=',$id);
            }
           
            $result = $result->leftJoin('users as u_send','image.sender_id','=','u_send.id')
                            ->leftJoin('users as u_reciver','image.receiver_id','=','u_reciver.id')
                            ->leftJoin('project_term as pt','image.status','=','pt.id')
                            ->select("image.id","image.sender_id","image.receiver_id","image.image","image.created_at","image.status","u_send.first_name as sender",'u_reciver.first_name as receiver','pt.term','image.title','image.description','image.image_place_name' )
                            ->get()
                            ->toArray();
             
            
            return response()->json(['success' => 1 , 'data' =>  $result]);
            
        }catch(Exception $exception) {    
            return response()->json(['success' => 0, 'message' => 'Something wrong']);
        }
    }

    public function filterStatus(Request $request){
        
        // Log::info(print_r($request->all(), true));
        $result = [];

        $result =  DB::table("image")
                    ->where('image.is_deleted',0)
                    ->leftJoin('users as u_send','image.sender_id','=','u_send.id')
                    ->leftJoin('users as u_reciver','image.receiver_id','=','u_reciver.id')
                    ->leftJoin('project_term as pt','image.status','=','pt.id')
                    ->select("image.id","image.sender_id","image.receiver_id","image.image","image.created_at","image.status","u_send.first_name as sender","u_send.last_name as sender_last",'u_reciver.first_name as receiver','u_reciver.last_name as receiver_last','pt.term','image.title','image.description','image.image_place_name' );
            

        if($request->status != 'all'){
            $result = $result->where('image.status','=', $request->status);
        }

        if(!empty($request->search)){

            $result = $result->Where(function ($query) use ($request) {
                            $query->where('u_send.first_name', 'like', '%'.$request->search.'%')
                                ->orWhere('u_send.last_name', 'like', '%'.$request->search.'%')
                                ->orWhere('image.image_place_name', 'like', '%'.$request->search.'%');
            });

        }
        $result = $result->get()->toArray();
      
        return response()->json(['success' => 1 , 'data' =>  $result]);

   }

   public function deleteImageweb(Request $request,$id){

    if (Image::where('id', $id)->exists())
    {
        $old_data = Image::findOrfail($request->id);  

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
}
