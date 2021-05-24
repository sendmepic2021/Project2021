<?php

namespace App\Http\Middleware;

use Closure;
use Auth;
use Session;
use DB;

class AuthCheckUser
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next) {
          
        if(auth()->user()){
            if(auth()->user()->user_type == 1){
                return $next($request);
            }
            else {
                return redirect('/');
            }
        }
        else {
            return redirect('/');
        }
    
    }
}
