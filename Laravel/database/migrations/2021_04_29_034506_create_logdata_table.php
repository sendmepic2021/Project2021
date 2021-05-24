<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateLogdataTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('logdata', function (Blueprint $table) {
            $table->id();
            $table->string('latitude')->nullable();
            $table->string('longitude')->nullable();
            $table->string('city')->nullable();
            $table->tinyInteger('is_login')->default(0);
            $table->integer('user_id')->nullable();
            $table->string('device_type')->nullable();
            $table->string('network_type')->nullable();
            $table->string('device_model')->nullable();
            $table->string('device_manufacture')->nullable();
            $table->string('device_brand')->nullable();
            $table->string('device_sdk_version')->nullable();
            $table->string('device_host')->nullable();
            $table->string('app_package')->nullable();
            $table->string('app_version')->nullable();
            $table->text('req_data')->nullable();
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
        Schema::dropIfExists('logdata');
    }
}
