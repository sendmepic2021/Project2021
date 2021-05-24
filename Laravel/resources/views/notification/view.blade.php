@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Notification View')
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/tables/datatable/datatables.min.css')}}">
@endsection
{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection
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
          <div class="col-12 col-md-4">
            <table class="table table-borderless">
            <h5 class="mb-2"> Notification </h5>
              <tbody>
              <tr>
                  <td>Id:</td>
                  <td>{{$notification->id}}</td>
                </tr>
                <tr>
                  <td>Type:</td>
                  <td><span class="badge badge-light-success ">{{notificationType($notification->notification_type)}}</span></td>
                </tr>
                <tr>
                  <td>Title:</td>
                  <td>{{$notification->notification_title}}</td>
                </tr>
                <tr>
                  <td>Description:</td>
                  <td>{{$notification->notification_description}}</td>
                </tr>
               
               
                <tr>
                  <td>Created Date:</td>
                  <td>{{parseDisplayDateTime($notification->created_at)}}</td>
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
  @if($notification->notification_type == 16)
  <div class="card">
    <div class="card-content">
      <div class="card-body">
      <div class="table-responsive">
        <div class="row bg-primary bg-lighten-5 rounded mb-2 mx-25 text-center text-lg-left">

        </div>
        <div class="col-12">
        <h5 class="mb-2"> Notification Users List</h5>
        <table id="notification-list-datatable" class="table">
          <thead>
                     <tr>
                        <th>id</th>
                        <th>Display name</th>
                        <th>Email</th>
                        <th>Device Type</th>
                     </tr>
                  </thead>
                  <tbody>
                     
                      @foreach($member as $key => $value)
                        <tr>
                            <td>{{$value->id}}</td>
                            <td>{{$value->display_name}}</td>
                            <td>{{$value->email	}}</td>
                            <td>{{getTypeofDeviceType($value->device_type)}}</td>
                        </tr>
                        @endforeach
                
                  </tbody>
          </table>
       
          </div>
   
        </div>
      </div>
    </div>
  </div>
  @endif
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