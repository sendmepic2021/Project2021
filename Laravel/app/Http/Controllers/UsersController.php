<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Image;
use DB;
use Illuminate\Support\Facades\Validator;
Use Exception;
use Carbon\Carbon;
use Illuminate\Support\Str;
use File;
use Illuminate\Support\Facades\Auth;
use Log;


class UsersController extends Controller
{
  //user List 
  public function listUser(){
    
    return view('user.page-users-list');
  }
    //user view 
    public function viewUser(){
    return view('user.page-users-view');
  }
   //user edit 
   public function editUser(){
    return view('user.page-users-edit');
  }

  public function Adminchangepasswordindex(Request $request,$id){

    $user = User::where('id',$id)->first();

    return view('auth.changepassword',compact('user'));

  }
 
  public function Adminchangepassword(Request $request,$id){   

            $user = User::where('id', $id)->first(); 
            if ($user)
            {
                if (password_verify($request->current_password, $user->password))
                {
                    $postArray = ['password' => bcrypt($request->new_password) ];
                    $login = User::where('id', $id)
                        ->update($postArray);
                    $user = User::where('id', $id)
                        ->first();
                    if ($login)
                    {

                      return redirect()->back()->with('message', 'Your password successfully changed.');
                    }
                }
                else
                {
                  return redirect()->back()->with('error', 'Old Password is invalid, Please enter valid password!.');
                }
            }
            else
            {
              return redirect()->route('dashboard')->with('error', 'The error message here!');
            }
       }


  public function AdminProfileGet(Request $request,$id){

    try{
    
      if (User::where('id', $id)->where('user_type', '=', 1)->exists()) {

        $user = User::where('id',$id)->where('user_type', '=', 1)->first();

        return view('user.adminedit',compact('user'));
      }
      else {
  
        return redirect()->route('dashboard')->with('error', 'User not found!');
        }
     
      }
    catch(Exception $exception)
    {  
      return redirect()->route('dashboard')->with('error', 'The error message here!');
    }
   
  }

  public function AdminProfileUpdate(Request $request,$id){

    if (User::where('id', $id)->where('user_type', '=', 1)->exists()) {
$image_name="";
      if ($request->hasFile('user_profile_image')) {

        $old_data = User::where('id',$id)->first();

        $image_path =  public_path('images/'.$old_data->user_profile_image);  // prev image path

        if(File::exists($image_path)) {
            File::delete($image_path); 
        }

        $filenameoriginal  = $request->file('user_profile_image')->getClientOriginalName();
    
        $image_name = 'users/Users'.'_'.time(). "." . $request->file('user_profile_image')->getClientOriginalExtension();
        
        $destinationPath = public_path('images/users');
        
        $request->file('user_profile_image')->move($destinationPath,$image_name);

        // User::where('id',$id)->update(array('user_profile_image' =>$image_name));

        }
       
        $user = User::findOrfail($id);      
        $user->display_name = $request->display_name;
        $user->public_name = $request->public_name;
        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->user_profile_image = $image_name;
        $user->mobile = $request->mobile;
       
        $user->update();
                  
        return redirect()->back()->with('message', 'Profile Update successfully!');
    }
    else {

      return redirect()->back()->with('error', 'User not found!');
      }
  }

  public function GetAllUser(){ 
    
      $users = User::where('user_type',2)->get();
      return view('user.userslist',compact('users'));
  }

  public function changeStatus(Request $request)
  {
      $user = User::find($request->id);
      $user->is_active = $request->is_active;
      $user->save();

      return 1;
  }


  public function UserProfileGetById(Request $request,$id){

    try{
    
      if (User::where('id', $id)->where('user_type', '=', 2)->exists()) {

        $user = User::where('id',$id)->where('user_type', '=', 2)->first();

        return view('user.usersedit',compact('user'));
      }
      else {
  
        return redirect()->route('dashboard')->with('error', 'User not found!');
        }
     
      }
    catch(Exception $exception)
    {  
      return redirect()->route('dashboard')->with('error', 'The error message here!');
    }
   
  }

  public function UpdateUserById(Request $request,$id){
try{
    if (User::where('id', $id)->where('user_type', '=', 2)->exists()) {

      if ($request->hasFile('user_profile_image')) {

        $old_data = User::where('id',$id)->first();

        $image_path =  public_path('images/'.$old_data->user_profile_image);  // prev image path

        if(File::exists($image_path)) {
            File::delete($image_path); 
        }

        $filenameoriginal  = $request->file('user_profile_image')->getClientOriginalName();
    
        $image_name = 'users/Users'.'_'.time(). "." . $request->file('user_profile_image')->getClientOriginalExtension();
    
        $destinationPath = public_path('images/users');
        
        $request->file('user_profile_image')->move($destinationPath,$image_name);

        User::where("id",$id)->update(array('user_profile_image' =>$image_name));

        }
        
        $user = User::findOrfail($id);      
        $user->display_name = $request->display_name;
        $user->public_name = $request->public_name;
        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->mobile = $request->mobile;
        $user->update();
                  
        return redirect()->route('users')->with('message', 'User Profile Update successfully!');
    }
    else {

      return redirect()->with('error', 'User not found!');
      }
    }
      catch(Exception $exception)
      {  
        return redirect()->route('dashboard')->with('error', 'The error message here!');
      }
  }

    public function UserViewByGetId($id){
     
     
      if (User::where('id', $id)->exists()) {

      // $users = DB::table('users as u')
      // ->where('u.id',$id)
      // ->leftJoin('image as i','i.receiver_id','=','u.id')
      // ->where('i.status',1)->where('i.is_receiver',1)
      // ->select('u.id','i.image')->get();

      $user = User::where('id',$id)->where('user_type',2)->first();

      $images = Image::where('receiver_id',$id)->where('status',13)->get()->toArray();
// pre($images);
      return view('user.view',compact('user','images'));
     
    }
    else {

      return redirect()->route('dashboard')->with('error', 'User not found!');
      }
    }
}
