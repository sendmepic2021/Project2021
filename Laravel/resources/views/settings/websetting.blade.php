@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Web Settings')
{{-- vendor styles --}}
@section('vendor-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/plugins/forms/validation/form-validation.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/forms/select/select2.min.css')}}">
<link rel="stylesheet" type="text/css" href="{{asset('vendors/css/pickers/pickadate/pickadate.css')}}">
@endsection
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
{{-- page styles --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/page-users.css')}}">
@endsection

@section('content')
@if(session()->has('message'))
<div class="alert alert-success">
   {{ session()->get('message') }}
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
                  <i class="bx bx-wrench mr-25"></i><span class="d-none d-sm-block">Web-Settings</span>
              </a>
          </li>
        
        </ul>
        <div class="tab-content">
          <div class="tab-pane active fade show" id="account" aria-labelledby="account-tab" role="tabpanel">
            <!-- users edit media object start -->
           
            <!-- users edit media object ends -->
            <!-- users edit account form start -->
            <form action="{{ route('websetting.update',$websetting->id) }}" method="POST">
            @csrf
                <div class="row">
                    <div class="col-12 col-sm-6">
                        <div class="form-group">
                            <div class="controls">
                                <label>Default Email</label>
                                <input type="text" class="form-control" placeholder="Default Email"
                                    value="{{$websetting->default_email}}" required name="default_email">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>SMTP-Port</label>
                                <input type="text" class="form-control" placeholder="SMTP-Port" name="smtp_port"
                                value="{{$websetting->smtp_port}}" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="controls">
                                <label>SMTP-Host</label>
                                <input type="text" class="form-control" placeholder="SMTP-Host" name="smtp_host"
                                value="{{$websetting->smtp_host}}" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="controls">
                                <label>SMTP-Password</label>
                                <input type="text" class="form-control" placeholder="SMTP-Password" name="smtp_password"
                                value="{{$websetting->smtp_password}}" required>
                            </div>
                        </div>
                    </div>


                    <div class="col-12 col-sm-6">
                      
                        
                        <div class="form-group">
                            <label>Email-Protocol</label>
                            <input type="text" class="form-control" value="{{$websetting->email_protocol}}" name="email_protocol" 
                            required placeholder="Email-Protocol">
                        </div>
                        <div class="form-group">
                            <label>SMTP-Crypto</label>
                            <input type="text" class="form-control" value="{{$websetting->smtp_crypto}}" name="smtp_crypto" 
                            required placeholder="SMTP-Crypto">
                        </div>
                        <div class="form-group">
                            <label>SMTP-From-Name</label>
                            <input type="text" class="form-control" value="{{$websetting->from_name}}" name="from_name"  
                            required placeholder="SMTP-From-Name">
                        </div>
                         <div class="form-group">
                            <label>SMTP-User</label>
                            <input type="text" class="form-control" value="{{$websetting->smtp_user}}" name="smtp_user"  
                            required placeholder="SMTP-User">
                        </div>
                    </div>

                    <div class="col-12 d-flex flex-sm-row flex-column justify-content-end mt-1">
                        <button type="submit" class="btn btn-primary glow mb-1 mb-sm-0 mr-0 mr-sm-1">Save
                            changes</button>
                            <a href="{{ url('websetting') }}" class="btn btn-light">Cancel</a>
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