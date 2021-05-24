@extends('layouts.contentLayoutMaster')
{{-- page title --}}
@section('title','Admin Edit')
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
              <span class="nav-link d-flex align-items-center active" id="account-tab" data-toggle="tab"
                   aria-controls="account" role="tab" aria-selected="true">
                  <i class="bx bx-user mr-25"></i><span class="d-none d-sm-block">Edit User Profile</span>
              </span>
          </li>

        </ul>
        @if(session()->has('message'))
    <div class="alert alert-success">
        {{ session()->get('message') }}
    </div>
        @endif


    <form action="{{ route('user.update',$user->id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="tab-content">
          <div class="tab-pane active fade show" id="account" aria-labelledby="account-tab" role="tabpanel">
            <!-- users edit media object start -->
            <div class="media mb-2">
                <a class="mr-2">
                    <img src="{{asset('images/'.$user->user_profile_image)}}" alt="users avatar"
                        class="users-avatar-shadow rounded-circle image-preview" height="64" width="64"  onerror="this.src = '{{defaultImage()}}';">
                </a>
                <div class="media-body">
                    
                    <div class="col-md-2 image-input">
                        <input type="file" name="user_profile_image" accept="image/*" id="imageInput">
                        <label for="imageInput" class="add-file-btn text-capitalize"><i class="bx bx-images mr-25"></i></label>
                        <!-- <span class="btn btn-sm btn-light-secondary change-image">Choose different image</span>   -->
                    </div>
                </div>
            </div>
            <!-- users edit media object ends -->
            <!-- users edit account form start -->
            
                <div class="row">
                    <div class="col-12 col-sm-6">
                        <div class="form-group">
                            <div class="controls">
                                <label>DisplayName</label>
                                <input type="text" class="form-control" name="display_name" placeholder="displayname"
                                    value="{{$user->display_name}}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>FirstName</label>
                                <input type="text" class="form-control" name="first_name" placeholder="firstname"
                                    value="{{$user->first_name}}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Mobile</label>
                                <input type="number" class="form-control" name="mobile" placeholder="number" minlength="7" onkeypress="if(this.value.length==13) return false;"
                                    value="{{$user->mobile}}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Social Id</label>
                                <input type="text" class="form-control" placeholder="Social Id"
                                    value="{{$user->social_id }}" Readonly>
                            </div>
                        </div>
                 
                    <div class="form-group">
                            <div class="controls">
                                <label>Latitude</label>
                                <input type="text" class="form-control" placeholder="Latitude"
                                    value="{{ $user->latitude }}" Readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Device Type</label>
                                <input type="text" class="form-control" placeholder="DeviceType"
                                    value="{{ getTypeofDeviceType($user->device_type) }}" Readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Profile Private/public</label>
                                <input type="text" class="form-control" placeholder="DeviceType"
                                    value="{{ is_profile($user->is_private_profile) }}" Readonly>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col-12 col-sm-6">
                    <div class="form-group">
                            <div class="controls">
                                <label>E-mail</label>
                                <input type="email" class="form-control" name="email" placeholder="Email"
                                    value="{{$user->email}}" Readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>LastName</label>
                                <input type="text" class="form-control" name="last_name" placeholder="lastname"
                                    value="{{$user->last_name}}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>UserType</label>
                                <input type="text" class="form-control" placeholder="UserType"
                                    value="{{ getTypeofUser($user->user_type) }}" Readonly>
                            </div>
                        </div>
                    
                    <div class="form-group">
                            <div class="controls">
                                <label>Login Type</label>
                                <input type="text" class="form-control" placeholder="Login Type"
                                    value="{{ getTypeofLogin($user->login_type) }}" Readonly>
                            </div>
                        </div>
         
                    <div class="form-group">
                            <div class="controls">
                                <label>Longitude</label>
                                <input type="text" class="form-control" placeholder="Longitude"
                                    value="{{ $user->longitude}}" Readonly>
                            </div>
                        </div>
                  
                    <div class="form-group">
                            <div class="controls">
                                <label>Level Id</label>
                                <input type="text" class="form-control" placeholder="Level Id"
                                    value="{{ $user->level_id }}" Readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="controls">
                                <label>Public Name</label>
                                <input type="text" class="form-control" name="public_name" placeholder="Public Name"
                                    value="{{$user->public_name}}">
                            </div>
                        </div>
                    </div>
          
                    <div class="col-12 d-flex flex-sm-row flex-column justify-content-end mt-1">
                        <button type="submit" class="btn btn-primary glow mb-1 mb-sm-0 mr-0 mr-sm-1">Save
                            changes</button>
                            <a href="{{ url()->previous() }}" class="btn btn-light">Cancel</a>
                    </div>
                </div>
           
            <!-- users edit account form ends -->
          </div>
        </div>
        </form>
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
<script>
    $('#imageInput').on('change', function() {
	$input = $(this);
	if($input.val().length > 0) {
		fileReader = new FileReader();
		fileReader.onload = function (data) {
		$('.image-preview').attr('src', data.target.result);
		}
		fileReader.readAsDataURL($input.prop('files')[0]);
		$('.image-button').css('display', 'block');
		$('.image-preview').css('display', 'block');
		$('.change-image').css('display', 'block');
	}
});
						
$('.change-image').on('click', function() {
	$control = $(this);			
	$('#imageInput').val('');	
	$preview = $('.image-preview');
	$preview.attr('src', '');
	$preview.css('display', 'block');
	$control.css('display', 'block');
	$('.image-button').css('display', 'block');
});
</script>
@endsection