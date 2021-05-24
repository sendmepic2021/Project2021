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
<style>
.main-grid {
	 display: grid;
	 grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
	 grid-gap: 1rem;
}
 .img-grid {
	 height: 20rem;
	 width: 100%;
	 object-fit: cover;
}
.remove-image {
    float: right;
}
</style>
@section('content')
<!-- users view start -->
<section class="users-view">
   <div class="users-list-filter px-1">
      <form>
         <div class="row border rounded py-2 mb-2">
            <div class="col-12 col-sm-3 col-lg-3">
               <label for="users-list-status">Status</label>
               <fieldset class="form-group">
                  <select class="form-control" id="users-list-status">
                     <option value="all">Any</option>
                     <option value="11">PENDING</option>
                     <option value="12">CONFIRM</option>
                     <option value="13">COMPLETED</option>
                     <option value="14">REJECTED</option>
                  </select>
               </fieldset>
            </div>
            <div class="col-12 col-sm-3 col-lg-3 d-flex align-items-center">
               <button class="btn btn-primary btn-block glow users-list-clear mb-0">Clear</button>
            </div>
            <div class="col-12 col-sm-3 col-lg-3">
            <label for="users-list-status">Search</label>
            <input type="text" id="search" class="form-control">
            </div>
            <div class="col-12 col-sm-3 col-lg-3 d-flex align-items-center">
               <button class="btn btn-primary btn-block glow users-list-search mb-0">Search</button>
            </div>
            
         </div>
      </form>
   </div>
                 <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog"
                    aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                    <div class="modal-dialog modal-lg" role="document">
                       <div class="modal-content">
                          <div class="modal-header">
                             <h5 class="modal-title" id="exampleModalScrollableTitle">Request Images</h5>
                             <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                             <i class="bx bx-x"></i>
                             </button>
                          </div>
                          <div class="modal-body">
                              <div id="model_body_iamge">
                                 
                              </div>

                          </div>
                       </div>
                    </div>
                 </div>
   
   <div class="users-list-filter px-1">
   <section id="decks">
      <div class="row match-height">
         <div class="col-12 mt-3 mb-1">
            <h4 class="text-uppercase">Today's images</h4>
         </div>
      </div>
      
      <div class="main-grid" id="img-container">
  
      </div>
   </section>
   <!-- users view card details ends -->
</section>
<!-- users view ends -->
@endsection
@section('vendor-scripts')
<script src="{{asset('vendors/js/tables/datatable/datatables.min.js')}}"></script>
<script src="{{asset('vendors/js/tables/datatable/dataTables.bootstrap4.min.js')}}"></script>
<script src="{{asset('js/scripts/modal/components-modal.js')}}"></script>
@endsection
{{-- page scripts --}}
@section('page-scripts')
<script src="{{asset('js/scripts/photo.js')}}"></script>
<script src="{{asset('js/scripts/pages/scripts.js')}}"></script>
@endsection