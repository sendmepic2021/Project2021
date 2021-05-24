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
  <!-- users view card data ends -->
  <!-- users view card details start -->
  <div class="users-list-filter px-1">
      <form>
         <div class="row border rounded py-2 mb-2">
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-devicetype">Device Type</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-devicetype">
                     <option value="">Any</option>
                     <option value="Android">Android</option>
                     <option value="Apple">Apple</option>
                     <option value="Web">Web</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-logintype">Login type</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-logintype">
                     <option value="">Any</option>
                     <option value="FaceBook">FaceBook</option>
                     <option value="Google">Google</option>
                     <option value="Apple">Apple</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
               <label for="users-list-is_active">Status</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-is_active">
                     <option value="">Any</option>
                     <option value="1">Active</option>
                     <option value="0">InActive</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-6 col-lg-3 d-flex align-items-center">
               <button type="reset" class="btn btn-primary btn-block glow users-list-clear mb-0">Clear</button>
            </div>
         </div>
      </form>
   </div>
  <section id="decks">
  <div class="row match-height">
    <div class="col-12 mt-3 mb-1">
      <h4 class="text-uppercase">Selected Area images</h4>
    </div>
  </div>

  @if(!$latlongs)
  <div class="alert alert-danger mb-2" role="alert">
            this distance area no more any image.
          </div>
   @endif


  <div class="masonry">

  @foreach($latlongs as $img)

   @if($img['distance'] < 10)
  <div class="item">
    <img src="{{asset('images/users/'.$img['image'])}}" onerror="this.src = '{{defaultImage()}}';">
    <p class="sender-name"><i class="bx bx-send"></i>
        {{UserGetName($img['sender_id'])}}
    </p>
    <small class="text-muted"><i class="bx bxs-calendar"></i> {{parseDisplayDate($img['created_at'])}}</small>
  </div>
  @endif

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