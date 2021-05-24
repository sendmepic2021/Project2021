<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateImageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('image', function (Blueprint $table) {
            $table->id();
            $table->string('title')->nullable();
            $table->text('description');
            $table->integer('sender_id');
            $table->integer('receiver_id');
            $table->string('image')->nullable();
            $table->tinyInteger('is_active')->default(1)->comment('0=Inactive,1=Active');
            $table->tinyInteger('is_receiver')->default(0)->comment('10=Not-Recived,9=Recived');
            $table->string('latitude')->nullable();
            $table->string('longitude')->nullable();
            $table->string('image_place_name')->nullable();
            $table->string('status')->default(1)->comment('11=Pending,12=Continue,13=Complate,14=Failed');
            $table->tinyInteger('is_deleted')->default(0);
            $table->tinyInteger('is_sender_show')->default(0);
            $table->tinyInteger('is_receiver_show')->default(0);
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
        Schema::dropIfExists('image');
    }
}
