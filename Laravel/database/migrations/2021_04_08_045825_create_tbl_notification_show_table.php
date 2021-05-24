<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTblNotificationShowTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('tbl_notification_show', function (Blueprint $table) {
            $table->id();
             $table->integer('user_id')->nullable();
             $table->integer('notification_id')->nullable();
             $table->tinyInteger('is_show_notification')->default(0)->comment('0=no,1=yes');
             $table->tinyInteger('is_deleted')->default(0);
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
        Schema::dropIfExists('tbl_notification_show');
    }
}
