@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Changepassword')
{{-- vendor styles --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/plugins/forms/validation/form-validation.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/forms/select/select2.min.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/pickers/pickadate/pickadate.css')}}">
@endsection

{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/plugins/forms/validation/form-validation.css')}}">

@endsection

@section('content')
@if(session()->has('message'))
<div class="alert alert-success">
   {{ session()->get('message') }}
</div>
@endif
@if(session()->has('error'))
    <div class="alert alert-danger">
        {{ session()->get('error') }}
    </div>
        @endif
<!-- users edit start -->
<section class="users-edit">
  <div class="card">
    <div class="card-content">
      <div class="card-body">
        <ul class="nav nav-tabs mb-2" role="tablist">
          <li class="nav-item">
              <a class="nav-link d-flex align-items-center active" id="account-tab" data-toggle="tab"
                   aria-controls="account" role="tab" aria-selected="true">
                  <i class="bx bx-lock mr-25"></i><span class="d-none d-sm-block">Change-Password</span>
              </a>
          </li>
        
        </ul>
        <div class="tab-content">
          <div class="tab-pane active fade show" id="account" aria-labelledby="account-tab" role="tabpanel">
            <!-- users edit media object start -->
           
            <!-- users edit media object ends -->
            <!-- users edit account form start -->
            <form action="{{ route('admin.update.password',$user->id) }}" method="POST">
            @csrf
                <div class="row">
                    <div class="col-12 col-sm-6">
                        <div class="form-group">
                            <div class="controls">
                                <label>Old Password</label>
                                <input type="password" class="form-control" placeholder="Old Password"
                                     name="current_password" required
                                    data-validation-required-message="This old password field is required">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>New Password</label>
                                <input type="password" class="form-control" placeholder="New Password" name="new_password"
                                 required  data-validation-required-message="The password field is required"
                                                                minlength="6">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="controls">
                                <label>Retype new Password</label>
                                <input type="password" class="form-control" placeholder="Retype new Password" name="con_password"
                                 required  data-validation-match-match="new_password" data-validation-required-message="The Confirm password field is required"
                                                                minlength="6">
                            </div>
                        </div>
                     
                    </div>
                    <div class="col-12 d-flex flex-sm-row flex-column justify-content-end mt-1">
                        <button type="submit" class="btn btn-primary glow mb-1 mb-sm-0 mr-0 mr-sm-1">Save
                            changes</button>
                            <a href="{{ url('dashboard') }}" class="btn btn-light">Cancel</a>
                    </div>
                </div>
            </form>
            <!-- users edit account form ends -->
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
<script src="{{asset('vendors/js/forms/validation/jqBootstrapValidation.js')}}"></script>
<script src="{{asset('vendors/js/pickers/pickadate/picker.js')}}"></script>
<script src="{{asset('vendors/js/pickers/pickadate/picker.date.js')}}"></script>
@endsection

{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/pages/page-users.js')}}"></script>
<script src="{{asset('js/scripts/navs/navs.js')}}"></script>
<script src="{{ asset('ckeditor/ckeditor.js') }}" type="text/javascript"></script>

@endsection