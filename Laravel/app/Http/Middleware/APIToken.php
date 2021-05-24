<?php

namespace App\Http\Middleware;

use Closure;
use Auth;
use App\User;
use Illuminate\Support\Str;

class APIToken
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
      RequestDataStoreInDB($request);
           if($request->header('access-token') != null && $request->header('access-token') != ""){


              if(Str::contains($request->header('access-token'),"Bearer ")){

                $token = str_replace("Bearer ", "",$request->header('access-token'));
                $user = User::where('token',$token)->first();
                if($user){
                  return $next($request);
      
                 }else{
                  return response()->json([
                    'status'=> 2,
                    'message' => 'Please enter valid token.',
                    'data'=>(object)[]
                  ]);
                 }
              } else {
                return response()->json([
                  'status'=> 2,
                  'message' => 'Unauthorized User.',
                  'data'=>(object)[]
                ]);
              }
            }
            else{
            return response()->json([
              'status'=>0,
              'message' => 'Authorization is missing.',
              'data'=>(object)[]
            ]);
          }
    }


}
