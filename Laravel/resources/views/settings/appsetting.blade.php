@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','App Settings')
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
                  <i class="bx bx-wrench mr-25"></i><span class="d-none d-sm-block">App-Settings</span>
              </a>
          </li>
        
        </ul>
        <div class="tab-content">
          <div class="tab-pane active fade show" id="account" aria-labelledby="account-tab" role="tabpanel">
            <!-- users edit media object start -->
           
            <!-- users edit media object ends -->
            <!-- users edit account form start -->
            <form action="{{ route('appsetting.update',$appsettings->id) }}" method="POST">
            @csrf
                <div class="row">
                    <div class="col-12 col-sm-6">
                        <div class="form-group">
                            <div class="controls">
                                <label>Android-Version</label>
                                <input type="text" class="form-control" placeholder="Android-Version"
                                    value="{{$appsettings->android_app_version}}" required name="android_app_version"
                                    data-validation-required-message="This username field is required">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="controls">
                                <label>Base-url</label>
                                <input type="text" class="form-control" placeholder="Base-url" name="base_url"
                                value="{{$appsettings->base_url}}" required
                                    data-validation-required-message="This name field is required">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Is-undermaintenance</label>
                            <select class="form-control" name="is_undermaintenance">
                            <option value="0" {{ "0" == $appsettings->is_undermaintenance ? 'selected' : '' }}>NO</option>
                            <option value="1" {{ "1" == $appsettings->is_undermaintenance ? 'selected' : '' }}>Yes</option>
                            </select>
                        </div>
                    </div>


                    <div class="col-12 col-sm-6">
                    <div class="form-group">
                            <div class="controls">
                                <label>Ios-Version</label>
                                <input type="text" class="form-control" placeholder="Ios-Version"
                                    value="{{$appsettings->ios_app_version}}" required name="ios_app_version"
                                    data-validation-required-message="This username field is required">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Image-Base-url</label>
                                <input type="text" class="form-control" placeholder="image-base-url" name="image_base_url"
                                value="{{$appsettings->image_base_url}}" required
                                    data-validation-required-message="This name field is required">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label>default-request-limit</label>
                            <input type="number" class="form-control" value="{{$appsettings->default_request_limit}}" name="default_request_limit"  placeholder="Request Limit">
                        </div>
                    </div>
  
                    <div class="col-12 col-sm-12">
                   
                      <div class="form-group">
                                  <label><h5><strong>Term and condition :</strong></h5></label>
                                  <textarea class="ckeditor form-control" name="term_and_condition">{!! $appsettings->term_and_condition !!}</textarea>
                        </div>
                    </div>
                   

                    <div class="col-12 col-sm-12">
                      <div class="form-group">
                                  <label><h5><strong>policy :</strong></h5></label>
                                  <textarea class="ckeditor form-control" name="policy">{!! $appsettings->policy !!}</textarea>
                        </div>
                    </div>

                    <div class="col-12 col-sm-12">
                      <div class="form-group">
                                  <label><h5><strong>about us :</strong></h5></label>
                                  <textarea class="ckeditor form-control" name="about_us">{!! $appsettings->about_us !!}</textarea>
                        </div>
                    </div>


                    <div class="col-12 d-flex flex-sm-row flex-column justify-content-end mt-1">
                        <button type="submit" class="btn btn-primary glow mb-1 mb-sm-0 mr-0 mr-sm-1">Save
                            changes</button>
                            <a href="{{ url()->previous() }}" class="btn btn-light">Cancel</a>
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