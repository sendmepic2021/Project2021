<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use DB;
use App\User;
use App\AppSetting;
use Illuminate\Support\Facades\Validator;
use File;
use Illuminate\Support\Str;
use App\Image;
Use Exception;

class AppSettingController extends Controller
{
    public function get_current_version(Request $request){

        try{

            $get_current_version = AppSetting::get(['android_app_version','ios_app_version','is_undermaintenance']);

            return response()->json([
                "status"=>1,
                "message" => "current version",
                "data"=>$get_current_version[0]
            ]);

        }catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => $exception, "data" => []]);
        }
    }

    public function get_cms_pages(Request $request,$type){

        try{
          
            if($type == 1){
                $get_term_and_condition = AppSetting::get(['term_and_condition']);

                $data['data_details'] = $get_term_and_condition[0]['term_and_condition'];
                return response()->json([
                 "status"=>1,
                 "message" => "Term and Condition pages",
                 "data"=>$data
                ]);
             } elseif($type == 2){
                $get_policy = AppSetting::get(['policy']);

                $data['data_details'] = $get_policy[0]['policy'];
                return response()->json([
                 "status"=>1,
                 "message" => "Policy pages",
                 "data"=>$data
                ]);
            } elseif($type == 3){
                $get_about_us = AppSetting::get(['about_us']);

                
                $data['data_details'] = $get_about_us[0]['about_us'];
                return response()->json([
                 "status"=>1,
                 "message" => "About us pages",
                 "data"=>$data
                ]);
            }
            else{
                return response()->json([
                    "status"=>0,
                    "message" => "Not found cms pages",
                    "data"=>(object)[]
                   ]);
            }
        }catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
        }

    }

    public function get_base_url(Request $request){
        try{

            $get_base_url = AppSetting::get(['base_url','image_base_url']);
// pre($get_base_url);
            return response()->json([
                "status"=>1,
                "message" => "base url",
                "data"=>$get_base_url[0]
            ]);

        }catch(Exception $exception)
        {
            return response()->json(["status" => 0, "message" => "Somthing went wrong", "data" => []]);
        }

    }

    public function getAllDataRequest(Request $request){
        
        return response()->json([
            "status"=>1,
            "message" => "base url",
            "data"=>$request->properties
        ]);
    }

}
