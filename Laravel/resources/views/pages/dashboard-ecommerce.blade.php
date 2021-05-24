@extends('layouts.contentLayoutMaster')
{{-- page Title --}}
@section('title','Dashboard')
{{-- vendor css --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/charts/apexcharts.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/extensions/swiper.min.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/tables/datatable/datatables.min.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/pickers/daterange/daterangepicker.css')}}">
@endsection
<style>
a.btn.btn-primary.all_usr_btn {
    position: absolute;
    top: 15px;
    right: 20px;
}
</style>
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/dashboard-ecommerce.css')}}">
@endsection
<link rel="stylesheet" type="text/css" href="{{asset('css/customstyle.css')}}">
@section('content')
@if(session()->has('error'))
    <div class="alert alert-danger">
        {{ session()->get('error') }}
    </div>
        @endif
<!-- Dashboard Ecommerce Starts -->
<section id="dashboard">
    <div class="row">
      <!-- Greetings Content Starts -->

      <!-- Multi Radial Chart Starts -->

          <!-- Statistics Cards Starts -->
          <div class="col-12">
            <div class="row">
              <div class="col-sm-4 col-12 dashboard-users-success">
                <div class="card text-center">
                  <div class="card-content">
                    <div class="card-body py-1">
                    <a href="{{ route('users') }}">
                    <div class="badge-circle badge-circle-lg badge-circle-light-danger mx-auto mb-50">
                        <i class="bx bx-user font-medium-5"></i>
                      </div>
                      <div class="text-muted line-ellipsis"> Total Users </div>
                      <h3 class="mb-0">{{$all_users}}</h3></a>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-sm-4 col-12 dashboard-users-danger">
             
                <div class="card text-center">
                  <div class="card-content">
                    <div class="card-body py-1">
                    <a href="{{ route('photos') }}">
                      <div class="badge-circle badge-circle-lg badge-circle-light-danger mx-auto mb-50">
                        <i class="bx bx-image font-medium-5"></i>
                      </div>
                      <div class="text-muted line-ellipsis"> Total Images </div>
                      <h3 class="mb-0">{{$all_images}}</h3></a>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-sm-4 col-12 dashboard-users-danger">
                <div class="card text-center">
                  <div class="card-content">
                    <div class="card-body py-1">
                    <a href="{{ route('notifications') }}">
                      <div class="badge-circle badge-circle-lg badge-circle-light-danger mx-auto mb-50">
                        <i class="bx bx-bell font-medium-5"></i>
                      </div>
                      <div class="text-muted line-ellipsis">Total Notification </div>
                      <h3 class="mb-0">{{$all_notification}}</h3></a>
                    </div>
                  </div>
                </div>
              </div>
         
            </div>
          </div>
          <!-- Revenue Growth Chart Starts -->
        </div>
      </div>


      <div class="card p-1">
    <div class="card-header">
      <!-- head -->
      
      <h5 class="card-title">Top 10 Users</h5>
      <a class="btn btn-primary all_usr_btn" href="{{ route('users') }}">All Users</a>
      <!-- Single Date Picker and button -->

    </div>
    <!-- datatable start -->
   
    <div class="table-responsive">
      <table id="table-extended-transactions" class="table mb-0">
      
        <thead>
        @php
           $i = 1;
        @endphp
          <tr>
            <th>NO.</th>
           
            <th>name</th>
            <th>email</th>
            <th>badge</th>
            <th>device type</th>
            <th>Login type</th>
          </tr>
        </thead>
        <tbody>
        @foreach($top_10_users as $usr)
          <tr>
            <td>{{$i++}}</td>
          
             <td>  @if($usr->display_name == null || $usr->display_name == "") - @else {{$usr->display_name}} @endif </td>
            <td> @if($usr->email == null || $usr->email == "") - @else {{$usr->email}} @endif</td>
            <td class="text-bold-600">{{getBadge($usr->level_id)}}</td>
            <td class="text-bold-600">{{getTypeofDeviceType($usr->device_type)}}</td>
            <td class="text-bold-600">{{getTypeofLogin($usr->login_type)}}</td>
          </tr>
          @endforeach
        </tbody>
      </table>
    </div>
    <!-- datatable ends -->
  </div>


<!-- ----------------------------image------------------ -->
<section id="decks">

<div class="row match-height">
    <div class="col-12 mt-3 mb-1">
      <h4 class="text-uppercase"> images</h4>
      <a class="btn btn-primary all_usr_btn" href="{{ route('photos') }}">All Images</a>
    </div>
  </div>

  <div class="masonry">

  @foreach($top_12_images as $img)

  <div class="item">
    <img src="{{asset('images/'.$img['image'])}}" onerror="this.src = '{{defaultImage()}}';" style="height:150px; width:100%; object-fit:cover;">
    <p class="sender-name"><i class="bx bx-send"></i>
       Sent: {{UserGetName($img['sender_id'])}}  
    </p>
    <p class="sender-name"><i class="bx bx-send"></i>
       Receiver: {{UserGetName($img['receiver_id'])}}  
    </p>
    <p class="sender-name"><i class="bx bxs-calendar"></i> {{parseDisplayDate($img['created_at'])}}</p>
      <p class="sender-name">Status : {{ImageStatus($img['status'])}}</p>  
  </div>

  @endforeach


</div>
</section>

    </div>

    
</section>

  



<!-- Dashboard Ecommerce ends -->
@endsection
{{-- vendor scripts --}}
@section('vendor-scripts')
<script src="{{asset('vendors/js/tables/datatable/datatables.min.js')}}"></script>
<script src="{{asset('vendors/js/tables/datatable/datatables.checkboxes.min.js')}}"></script>
<script src="{{asset('vendors/js/charts/apexcharts.min.js')}}"></script>
<script src="{{asset('vendors/js/pickers/daterange/moment.min.js')}}"></script>
<script src="{{asset('vendors/js/pickers/daterange/daterangepicker.js')}}"></script>
@endsection

{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/pages/table-extended.js')}}"></script>
@endsection 


