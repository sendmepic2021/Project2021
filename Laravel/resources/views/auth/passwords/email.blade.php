@extends('layouts.fullLayoutMaster')
{{-- page title --}}
@section('title','Forgot Password')
{{-- page scripts --}}
@section('page-styles')
<link rel="stylesheet" type="text/css" href="{{asset('css/pages/authentication.css')}}">
@endsection

@section('content')
<!-- forgot password start -->
<section class="row flexbox-container">
  <div class="col-xl-7 col-md-9 col-10  px-0">
    <div class="card bg-authentication mb-0">
      <div class="row m-0">
        <!-- left section-forgot password -->
        <div class="col-md-6 col-12 px-0">
          <div class="card disable-rounded-right mb-0 p-2">
            <div class="card-header pb-1">
              <div class="card-title">
                <h4 class="text-center mb-2">Forgot Password?</h4>
              </div>
            </div>
           
            <div class="card-content">
              <div class="card-body">
                <div class="text-muted text-center mb-2">
                  <small>Enter the email  you used when you joined and we will send you change password email</small>
                </div>
                {{-- form --}}
                <form class="mb-2" method="POST" action="{{ route('password.email') }}">
                  @csrf
                  <div class="form-group mb-2">
                    <label class="text-bold-600" for="email">Email</label>
                    <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" name="email" value="{{ old('email') }}" autocomplete="email" autofocus placeholder="Email or Phone">
                    @error('email')
                      <span class="invalid-feedback" role="alert">
                        <strong>{{ $message }}</strong>
                      </span>
                    @enderror
                  </div>
                  <button type="submit" class="btn btn-primary glow position-relative w-100">SUBMIT
                    <i id="icon-arrow" class="bx bx-right-arrow-alt"></i>
                  </button>
                </form>

                <div class="text-center mb-2">
                  <a href="{{route('login')}}">
                    <small class="text-muted">I remembered my password</small>
                  </a>
                </div>
  
              </div>
            </div>
          </div>
        </div>
        <!-- right section image -->
        <div class="col-md-6 d-md-block d-none text-center align-self-center">
          <img class="img-fluid" src="{{asset('images/pages/forgot-password.png')}}" alt="branding logo" width="300">
        </div>
      </div>
    </div>
  </div>
</section>
<!-- forgot password ends -->
@endsection
