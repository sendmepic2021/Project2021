@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Users List')
{{-- vendor styles --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/tables/datatable/datatables.min.css')}}">
@endsection
{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection
<style>
.table .row:nth-child(2) {
    overflow-x: auto;
}
</style>
<link rel="stylesheet" type="text/css" href="{{asset('css/customstyle.css')}}">
@section('content')
@if(session()->has('message'))
<div class="alert alert-success">
   {{ session()->get('message') }}
</div>
@endif
<!-- users list start -->

<section class="users-list-wrapper">
   <div class="users-list-filter px-1">
      <form>
         <div class="row border rounded py-2 mb-2">
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-devicetype">Device Type</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-devicetype">
                     <option value="">Any</option>
                     <option value="Android">Android</option>
                     <option value="Apple">Apple</option>
                     <option value="Web">Web</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-logintype">Login type</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-logintype">
                     <option value="">Any</option>
                     <option value="FaceBook">FaceBook</option>
                     <option value="Google">Google</option>
                     <option value="Apple">Apple</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-is_active">Status</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-is_active">
                     <option value="">Any</option>
                     <option value="1">Active</option>
                     <option value="0">InActive</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3 d-flex align-items-center">
               <button type="reset" class="btn btn-primary btn-block glow users-list-clear mb-0">Clear</button>
            </div>
         </div>
      </form>
   </div>
   <div class="users-list-table">
      <div class="card">
         <div class="card-content">
            <div class="card-body">
               <!-- datatable start -->
               <div class="table">
                  <table id="users-list-datatable" class="table">
                     <thead>
                        <tr>
                           <th>no.</th>
                           <th>image</th>
                           <th>Public Name</th>
                           <th>First Name</th>
                           <th>Last Name</th>
                           <th>Email</th>
                           <th>Badge</th>
                           <th>Login Type</th>
                           <th>Device Type</th>
                           <th>Active/Inactive</th>
                           <th>Actions</th>
                        </tr>
                     </thead>
                     <tbody>
                        @foreach($users as $key => $user)
                        <tr>
                           <td>{{$key+1}}</td>
                           <td><img src="{{asset('images/'.$user->user_profile_image)}}" alt="users avatar"
                              class="users-avatar-shadow media-bordered rounded-circle" height="30" width="30"  onerror="this.src = '{{defaultImage()}}';"></td>
                              <td>{{$user->public_name}}</td>
                           <td>{{$user->first_name}}</td>
                           <td>{{$user->last_name}}</td>
                           <td>{{$user->email}}</td>
                           <td class="text-bold-600">{{getBadge($user->level_id)}}</td>
                           <td>{{getTypeofLogin($user->login_type)}}</td>
                          
                           <td>{{getTypeofDeviceType($user->device_type)}}</td>
                           <td>
                              <center><input type="checkbox" data-id="{{ $user->id }}" name="is_active" class="js-switch" {{ $user->is_active == 1 ? 'checked' : '' }}></center>
                           </td>
                           <td>
                           <div class="dropdown">
                <span class="bx bx-dots-horizontal-rounded font-medium-3 dropdown-toggle nav-hide-arrow cursor-pointer" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" role="menu">
                </span>
                <div class="dropdown-menu dropdown-menu-right" style="">
                  <a class="dropdown-item" href="{{url('/user/view',$user->id)}}"><i class="bx bx-show mr-1"></i> view</a>
                  <a class="dropdown-item" href="{{url('/user/edit',$user->id)}}"><i class="bx bx-edit-alt mr-1"></i> edit</a>
                </div>
              </div>
            </td>
                        
                        </tr>
                        @endforeach
                     </tbody>
                  </table>
               </div>
               <!-- datatable ends -->
            </div>
         </div>
      </div>
   </div>
</section>
<!-- users list ends -->
@endsection
{{-- vendor scripts --}}
@section('vendor-scripts')
<script src="{{asset('vendors/js/tables/datatable/datatables.min.js')}}"></script>
<script src="{{asset('vendors/js/tables/datatable/dataTables.bootstrap4.min.js')}}"></script>
@endsection
{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/pages/page-users.js')}}"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/switchery/0.8.2/switchery.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/switchery/0.8.2/switchery.min.js"></script>
<script>let elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
   elems.forEach(function(html) {
       let switchery = new Switchery(html,  { size: 'small' });
   });
</script>
<script src="{{asset('js/scripts/custom.js')}}"></script>
@endsection