<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Image;
use App\Notification;
use App\NotificationShow;
use DB;
use File;

class removeImageHoure extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'image:remove';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        \Log::info("Cron is working fine ImageDataRemove Cron!");
        
        // DB::table('image')->where('created_at' ,'<=', date('Y-m-d H:i:s',strtotime('-24 hours')))->get();
        $all_images = DB::table('image')->where('created_at' ,'<=', date('Y-m-d H:i:s',strtotime('-24 hours')))->get(['id'])->toArray();
        foreach($all_images as $val){
    
          $old_data = Image::where('id',$val->id)->first();
    
          $image_path =  public_path('images/'.$old_data->image);  // prev image path
      
          if(File::exists($image_path)) {
              File::delete($image_path); 
          }
      
            Image::where("id",$val->id)->update(array('image' =>Null,'is_deleted'=>1));
        //notificaiton remove 
            $notification_array = Notification::whereIn('request_id',[$val->id])->get();
           
            foreach($notification_array as $key => $value){

             $show_notification = NotificationShow::where('notification_id',$value['id'])->update(['is_deleted'=>1]);
      
            }
        }
      
        $this->info('Logdata:Cron Cummand Run successfully Image Remove Cron!');
    }
}
