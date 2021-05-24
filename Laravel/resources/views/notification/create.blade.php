@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Notification Create')
{{-- vendor styles --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/plugins/forms/validation/form-validation.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/forms/select/select2.min.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/pickers/pickadate/pickadate.css')}}">
@endsection

{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection
<link rel="stylesheet" type="text/css" href="{{asset('css/customstyle.css')}}">
@section('content')
<!-- users edit start -->
<section class="users-edit">
  <div class="card">
    <div class="card-content">
      <div class="card-body">
        <ul class="nav nav-tabs mb-2" role="tablist">
          <li class="nav-item">
              <a class="nav-link d-flex align-items-center active" id="account-tab" data-toggle="tab"
                  aria-controls="account" role="tab" aria-selected="true">
                  <i class="bx bx-bell mr-25"></i><span class="d-none d-sm-block">Notification</span>
              </a>
          </li>
         
        </ul>
        <div class="tab-content">
          <div class="tab-pane active fade show" id="account" aria-labelledby="account-tab" role="tabpanel">
            <!-- users edit media object start -->
           
            <form action="{{ route('notifications.store') }}" method="POST">
            @csrf
              <div class="row">
                <div class="col-12 col-sm-6">
                
                  <div class="form-group">
                      <label>Title</label>
                      <input class="form-control" name="notification_title" type="text" Required> 
                  </div>

                  <div class="form-group">
                    <label>Type</label>
                    <select class="form-control" id="TypeSelect" name="notification_type" Required>
                    <option value="" selected>Please select Type</option>
                        <option value="15">All User</option>
                        <option value="16">Multiple User</option>
                    </select>
                  </div>
                </div>


                <div class="col-12 col-sm-6 mt-1 mt-sm-0" hide>
                
                <div class="form-group">
                    <div class="controls">
                      <label>Description</label>
                      <input type="text" class="form-control" name="notification_description" placeholder="Description"
                      Required>
                    </div>
                  </div>
                  
                  <div class="form-group hide">
                    <label>Please Select User</label>
                    <select class="form-control" id="noti-users-select2" multiple="multiple" name="user_id[]">                   
                    @if(!empty($users))
                    @foreach($users as $user)
                    @php 
                    echo '<option value="'.$user['id'].'">'.$user['display_name'].'</option>';
                    @endphp
                    @endforeach
                    @endif                     
                    </select>
                  </div>  
                </div>
                <div class="col-12 d-flex flex-sm-row flex-column justify-content-end mt-1">
                        <button type="submit" id="submit" class="btn btn-primary glow mb-1 mb-sm-0 mr-0 mr-sm-1">Save
                            </button>
                        <a href="{{ url()->previous() }}" class="btn btn-light">Cancel</a>
             
                </div>
              </div>
            </form>
            <!-- users edit account form ends -->
          </div>
          <div class="tab-pane fade show" id="information" aria-labelledby="information-tab" role="tabpanel">
            <!-- users edit Info form start -->
       
            <!-- users edit Info form ends -->
          </div>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- users edit ends -->
@endsection

{{-- vendor scripts --}}
@section('vendor-scripts')
<script src="{{asset('vendors/js/forms/select/select2.full.min.js')}}"></script>
@endsection

{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/navs/navs.js')}}"></script>
<script src="{{asset('js/scripts/notification.js')}}"></script>
@endsection