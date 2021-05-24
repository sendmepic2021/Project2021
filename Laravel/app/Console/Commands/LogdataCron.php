<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use DB;

class LogdataCron extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'logdata:cron';

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
        \Log::info("Cron is working fine LogData Cron!");
        
        DB::table('logdata')->truncate();
        
      
        $this->info('Logdata:Cron Cummand Run successfully LogData Cron!');
    }
}
