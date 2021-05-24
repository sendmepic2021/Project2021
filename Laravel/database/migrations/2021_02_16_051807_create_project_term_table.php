<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProjectTermTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('project_term', function (Blueprint $table) {
            $table->id();
            $table->string('term');
            $table->string('category');
            $table->tinyInteger('is_active')->default(1)->comment('0=Inactive,1=Active');
            $table->string('default_value')->default('');
            $table->string('icon')->default('');
            $table->string('term_code')->default('');
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
        Schema::dropIfExists('project_term');
    }
}
