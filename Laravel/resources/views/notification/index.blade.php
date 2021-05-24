@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Notificatinos List')
{{-- vendor styles --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/tables/datatable/datatables.min.css')}}">
@endsection
{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection
<link rel="stylesheet" type="text/css" href="{{asset('css/customstyle.css')}}">
@section('content')

@if(session()->has('message'))
    <div class="alert alert-success">
        {{ session()->get('message') }}
    </div>
        @endif
<!-- users list start -->
<a class=" btn btn-primary mr-1 mb-1" href="{{ route('notifications.create') }}"><i class="bx bx-plus"></i> Send Notification</a>
<section class="users-list-wrapper">
<div class="notification-list-table">
   <div class="card">
      <div class="card-content">
         <div class="card-body">
            <!-- datatable start -->
            <div class="table-responsive">
               <table id="notification-list-datatable" class="table">
                  <thead>
                     <tr>
                        <th>id</th>
                        <th>Type</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Created At</th>
                        <th>Action</th>
                     </tr>
                  </thead>
                  <tbody>
                  @foreach($notifications as $key => $noti)
                      <tr>
                      <td>{{$key+1}}</td>
                      <td>{{notificationType($noti->notification_type)}}</td>
                      <td>{{$noti->notification_title}}</td>
                      <td><p>{{$noti->notification_description}}</p></td>
                      <td>{{parseDisplayDateTime($noti->created_at)}}</td>
                      <td><a href="{{url('/notification/show',$noti->id)}}" class="float-top btn-btn-primary"><i
                              class="bx bxs-show"></i></a></td>
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
<script src="{{asset('js/scripts/notification.js')}}"></script>
@endsection