<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:api')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::get('/cache-clear', function()
{
    
    Artisan::call('cache:clear');
    Artisan::call('config:clear');
    Artisan::call('config:cache');
    Artisan::call('view:clear');
    Artisan::call('route:clear');
    return "Cleared!";
    
});

    Route::get('/removed_images', function()
{
    Artisan::call('image:remove');
    return "Cleared!";
});



Route::group(['prefix' => 'v1', 'namespace' => 'Mobile'], function () {


      Route::post('/login', 'UsersController@Login');
// aa nikadavani che!!
      Route::post('/getAllDataRequest', 'AppSettingController@getAllDataRequest');
      //App Settings
      Route::get('/get_current_version', 'AppSettingController@get_current_version');
      Route::get('/get_cms_pages/{type}', 'AppSettingController@get_cms_pages');
      Route::get('/get_base_url', 'AppSettingController@get_base_url');
      Route::get('/image_base_url', 'AppSettingController@image_base_url');
      Route::post('/user_fcm_id_update', 'UsersController@UpdateFcmId');
//    ----------------------------------------------------------------------------------------------------------------------
// Aurothrization token

Route::middleware('APIToken')->group(function()
{
    //User 
    Route::post('/logout', 'UsersController@Logout');

    Route::get('/getUserbyid/{id}', 'UsersController@GetUserById');
 
    Route::post('/user_update_profile_by_id', 'UsersController@UserUpdateProfileById');
 
    Route::post('/update_notification', 'UsersController@IsNotificationActiveInactive');
 
    Route::post('/update_profile_private_public', 'UsersController@IsProfilePrivateActiveInactive');
 
    Route::post('/get_user_details_by_lat_long', 'UsersController@getUserAndImageByLatLong');
 
    Route::post('/update_user_location', 'UsersController@updateUserLocation');

    Route::post('/getDashboardCount', 'UsersController@getDashboardCount');
 
 
    // Image 
 
    Route::post('/send_request_user_for_image', 'ImageController@SendRequestApiForImage');
 
    Route::get('/get_all_request_by_sender/{id}', 'ImageController@GetAllRequestSenderId');
 
    Route::get('/get_request_detail_by_id/{id}', 'ImageController@GetRequestDetailById');
 
    Route::get('/get_all_request_by_receiver/{id}', 'ImageController@GetAllRequestReceviverId');
 
    Route::post('/update_status_by_id', 'ImageController@UpdateStatusOfRequestId');
 
    Route::post('/upload_image_by_sender', 'ImageController@UploadImageOfRequestId');
 
    Route::get('/get_image_center_point', 'ImageController@GetCenterFromDegreesByLatLong');
 
    Route::get('/culsterUserByLatLong', 'ImageController@culsterUserByLatLong');
 
    Route::post('/image_array_get_details', 'ImageController@imageArrayGetDetails');
 
    Route::post('/by_lat_long_search', 'ImageController@byLatLongSearchKey');
 
    Route::post('/send_multiple_request_user_for_image', 'ImageController@sendMultipleRequestToimage');

    Route::post('/deleteImage', 'ImageController@deleteImage');

    Route::post('/showSentRequest', 'ImageController@showSentRequest');

    Route::post('/showReceiveRequest', 'ImageController@showReceiveRequest');

    //Notification
    Route::get('/get_notification_by_id/{id}', 'NotificationController@get_notification_by_id');

    Route::get('/get_notification_by_user_id/{id}', 'NotificationController@getNotificationUserById');

    Route::post('/updateNotificationStatusById', 'NotificationController@updateNotificationStatusById');

    Route::post('/showAllNotificationByUserId', 'NotificationController@showAllNotificationByUserId');

});

});




