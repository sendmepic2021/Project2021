<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Image;
use App\Notification;
use DB;
use Illuminate\Support\Facades\Validator;
Use Exception;
use Carbon\Carbon;
use Illuminate\Support\Str;
use File;

class DashboardController extends Controller
{
    
    public function dashboardEcommerce(){

        $params['all_users'] = User::where('user_type', 2)->count();

        $params['all_images'] = Image::where('is_deleted',0)->count();

        $params['all_notification'] = Notification::where('screen_id',null)->where('request_id',null)->count();

        $top_10_users = User::orderBy('id', 'desc')->where('user_type',2)->take(10)->get();

        $params['top_12_images'] = Image::where('is_deleted',0)->orderBy('id', 'desc')->take(12)->get();

        return view('pages.dashboard-ecommerce',$params ,compact('top_10_users'));
    }

}
