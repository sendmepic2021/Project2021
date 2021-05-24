<?php
use Illuminate\Support\Facades\Route;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
// dashboard Routes
Auth::routes();

Route::get('/', function () {
    return view('auth.login');
});

Route::get('/privacy_policy', function () {
    $privacy_policy = DB::table('app_setting')->first();
    return view('privacy_policy',compact('privacy_policy'));
});
Route::get('/terms_conditions', function () {
    $terms_conditions = DB::table('app_setting')->first();
    return view('terms_conditions',compact('terms_conditions'));
});
Route::get('/about_us', function () {
    $about_us = DB::table('app_setting')->first();
    return view('about_us',compact('about_us'));
});

Route::group(['middleware' => 'AuthCheckUser'], function () {
 
    Route::get("dashboard",["uses"=>"DashboardController@dashboardEcommerce"])->name('dashboard');
    Route::get('/logout', 'Auth\LoginController@logout')->name('logout');

    //User
    Route::get("user",["uses"=>"UsersController@GetAllUser"])->name('users');

    Route::get('/user/edit/{id}', 'UsersController@UserProfileGetById')->name('user.edit');

    Route::post('/user/update/{id}', 'UsersController@UpdateUserById')->name('user.update');

    Route::get("/status/update",['uses'=>'UsersController@changeStatus']);

    Route::get('/admin/edit/{id}', 'UsersController@AdminProfileGet')->name('admin.edit');

    Route::post('/admin/update/{id}', 'UsersController@AdminProfileUpdate')->name('admin.update');

    Route::get('/user/view/{id}', 'UsersController@UserViewByGetId')->name('user.view');

    //Admin Change password

    Route::get('/admin/changepassword/{id}', 'UsersController@Adminchangepasswordindex');

    Route::post('/admin/update/password/{id}', 'UsersController@Adminchangepassword')->name('admin.update.password');
    
    //Notifications

    Route::get("notifications",["uses"=>"NotificationController@GetAllNotification"])->name('notifications');

    Route::get("notifications/create",["uses"=>"NotificationController@CreateNotification"])->name('notifications.create');

    Route::post("notifications/store",["uses"=>"NotificationController@notification_store"])->name('notifications.store');

    Route::get('/notification/show/{id}', 'NotificationController@notificationGetById')->name('notification.show');

   //App Settings

   Route::get('/appsettings', 'SettingController@AppSettings')->name('appsettings');

   Route::post('/appsetting/update/{id}', 'SettingController@UpdateAppSettings')->name('appsetting.update');

   //Web Settings

   Route::get('/websetting', 'SettingController@WebSettings')->name('websetting');

   Route::post('/websetting/update/{id}', 'SettingController@UpdateWebSettings')->name('websetting.update');

   //Search Images

    Route::get('photos', 'ImageController@SearchGetAllImages')->name('photos');

    Route::post('/filter/status', 'ImageController@filterStatus');

    Route::post('/delete/{id}', 'ImageController@deleteImageweb');

});


// Route::get('/Dashboard','DashboardController@dashboardEcommerce');
// Route::get('/dashboard-ecommerce','DashboardController@dashboardEcommerce');
// Route::get('/dashboard-analytics','DashboardController@dashboardAnalytics');


