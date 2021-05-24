<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('display_name');
            $table->string('first_name');
            $table->string('last_name');
            $table->string('public_name')->default('Anonymous');
            $table->string('user_profile_image')->nullable();
            $table->string('email')->nullable();
            $table->string('mobile',17)->nullable();
            $table->string('password')->nullable();
            $table->string('fcm_id')->nullable();  
            $table->string('device_type',17)->comment('6=android,7=apple,8=web');
            $table->string('social_id')->nullable();
            $table->tinyInteger('is_active')->default(1)->comment('0=Inactive,1=Active');
            $table->text('token')->nullable();
            $table->integer('user_type')->comment('1=Admin,2=User');
            $table->integer('login_type')->comment('3=facebook,4=google,5=apple');
            $table->integer('package_id')->default(0);
            $table->string('latitude')->nullable();
            $table->string('longitude')->nullable();
            $table->string('palace_name')->nullable();
            $table->integer('level_id')->default(0);
            $table->tinyInteger('is_notification')->default(0)->comment('0=on,1=off');
            $table->tinyInteger('is_private_profile')->default(0)->comment('0=public,1=private');
            $table->timestamp('email_verified_at')->nullable();
            $table->rememberToken();
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
        Schema::dropIfExists('users');
    }
}
