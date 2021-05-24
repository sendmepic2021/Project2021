<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAppSettingTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('app_setting', function (Blueprint $table) {
            $table->id();
            $table->string('android_app_version');
            $table->string('ios_app_version');
            $table->text('term_and_condition');
            $table->text('policy');
            $table->text('about_us');
            $table->tinyInteger('is_undermaintenance')->default(0)->comment('0=Inactive,1=Active');
            $table->string('base_url');
            $table->string('image_base_url');
            $table->integer('default_request_limit');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('app_setting');
    }
}
