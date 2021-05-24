@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Users View')
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/tables/datatable/datatables.min.css')}}">
@endsection
{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection
<link rel="stylesheet" type="text/css" href="{{asset('css/customstyle.css')}}">
@section('content')
<!-- users view start -->
<section class="users-view">
  <!-- users view media object start -->
  
  <!-- users view media object ends -->
  <!-- users view card data start -->
  <div class="card">
    <div class="card-content">
      <div class="card-body">
        <div class="row">
        <div class="col-6 col-md-2">
              <img src="{{asset('images/'.$user->user_profile_image)}}" onerror="this.src = '{{defaultImage()}}';" style="width:100%; object-fit:cover;">
          </div>

          <div class="col-6 col-md-6">
          <table class="table table-borderless">
           
           <tbody>
          <tr>
                  <td>Full Name</td>
                  <td>{{$user->first_name}} {{$user->last_name}}</td>
                </tr>
                <tr>
                  <td>Display Name:</td>
                  <td> @if($user->display_name == null || $user->display_name == "") - @else {{$user->display_name}} @endif</td> 
                </tr>
                <tr>
                  <td>Public Name</td>
                  <td>{{$user->	public_name}}</td>
                </tr>
                <tr>
                  <td>Email:</td>
                  <td>{{$user->email}}</td>
                </tr>
                <tr>
                  <td>Mobile:</td>
                  <td> @if($user->mobile == null || $user->mobile == "") - @else {{$user->mobile}} @endif</td> 
                </tr>
                </tbody>
            </table>
          </div>

          <div class="col-6 col-md-4">
            <table class="table table-borderless">
           
              <tbody>
             
                <tr>
                  <td>Device Type:</td>
                  <td>{{getTypeofDeviceType($user->device_type)}}</td>
                </tr>
                <tr>
                  <td>Login Type:</td>
                  <td>{{getTypeofLogin($user->login_type)}}</td>
                </tr>
                <tr>
                  <td>Badge Level:</td>
                  <td>{{getBadge($user->level_id)}}</td>
                </tr>
                <tr>
                  <td>Notification:</td>
                  <td>{{notificationOnOff($user->is_notification)}}</td>
                </tr>
                <tr>
                  <td>Profile Private</td>
                  <td>{{profileonOnOff($user->is_private_profile)}}</td>
                </tr>

              </tbody>
            </table>
          </div>
      
        </div>
      </div>
    </div>
  </div>
  <!-- users view card data ends -->
  <!-- users view card details start -->

  <section id="decks">
  <div class="row match-height">
    <div class="col-12 mt-1 mb-1">
      <h4 class="text-uppercase">Gallery</h4>
    </div>
  </div>

  @if(!$images)
  <div  role="alert" style="    align-content: center;
    text-align: center;">
            No pictures found!.
          </div>
   @endif


  <div class="masonry">

  @foreach($images as $img)
  <div class="item">

    <img src="{{asset('images/'.$img['image'])}}" onerror="this.src = '{{defaultImage()}}';">
    <p class="sender-name"><i class="bx bx-send"></i>
        {{UserGetName($img['sender_id'])}}
    </p>
    <small class="text-muted"><i class="bx bxs-calendar"></i> {{parseDisplayDate($img['created_at'])}}</small>
  </div>
  @endforeach
</div>

</section>

  <!-- users view card details ends -->

</section>
<!-- users view ends -->
@endsection
@section('vendor-scripts')
<script src="{{asset('vendors/js/tables/datatable/datatables.min.js')}}"></script>
<script src="{{asset('vendors/js/tables/datatable/dataTables.bootstrap4.min.js')}}"></script>
@endsection
{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/notification.js')}}"></script>
@endsection