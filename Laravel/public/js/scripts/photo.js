$('body').on('click', '.remove-image', function(e) {
                
    e.preventDefault();

    var id= $(this).attr('data-id');

    confirmDialogMessage('Remove Image', 'Are you sure want to remove image?', () => {
        
        $.ajax({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            },
            type:'POST',
            url:'/delete/'+id,
            processData: false,
            contentType: false,
            success: function(response) {
                if(response.status==1){
                showSuccessMessage(response.message)
                $(".users-list-clear").trigger('click');
                }else{
                    showErrorMessage(response.message)
                }
               
            },
            error:function(jqXHR, textStatus, ex){ 
               
            console.log(jqXHR.responseText);
               
            }
        });
      
    });

});

var all_images_data = [];
    $('body').on("change", "#users-list-status",function(e){
       
        filter();
    });

    $('body').on("click", "#users-list-status",function(e){
        $('#search').val('');
        filter();
    });
    

    $('body').on("click", ".users-list-search",function(e){
        e.preventDefault();
        filter();
    });

    $('#search').keyup( function() {
        var search_char = this.value.length;
        if(search_char < 1){
            $('#users-list-status').val('all').trigger('change');
        }else{
            
            $(".users-list-search").trigger('click');
        }
     });

    $('body').on("click", ".users-list-clear",function(e){
        e.preventDefault();
        $('#users-list-status').val('all').trigger('change');
        $('#search').val('');
    });

    $( document ).ready(function() {
        $(".users-list-clear").trigger('click');
    });

    $('body').on('click', '.image_popup', function() {
        var image_id = $(this).attr('data-id');
        var details = getDetailsFromObjectByKey(all_images_data, image_id, 'id');
        var html = '';

        html +='   <div class="row">';
        html +='       <div class="col-md-6">';
        html +='           <img src=" '+(details.image == null  ? '/no-image.svg' : '/images/'+details.image+'')+' " alt="" srcset="" style="width:100%; height:467px; object-fit: contain;">';
        html +='       </div>';
        html +='         <div class="col-md-6" style=" height:467px; overflow-y:auto">';
        
        html +='        <p><b>Sender :<br> </b>'+details.sender+' '+details.sender_last+' </p>';
        html +='        <p><b>Receiver :<br> </b>'+details.receiver+' '+details.receiver_last+'</p>';
       // html +='        <p><b>Status :<br> </b>'+details.term+'</p>';

       html += '<b>Status :<br> </b>';
       if (details.status == 11) {
                        
        html +=   "<span class='badge badge-light-warning' style='padding: 0.25rem 0.45rem;'>Pending</span>";
    }
    if (details.status == 12) {
        html +=   "<span class='badge badge-light-info' style='padding: 0.25rem 0.45rem;'>Confirm</span>";
    }
    if (details.status == 13) {
        html +=   "<span class='badge badge-light-success' style='padding: 0.25rem 0.45rem;'>Completed</span>";
    }
    if (details.status == 14) {
        html +=   "<span class='badge badge-light-danger' style='padding: 0.25rem 0.45rem;'>Rejected</span>";
    }
    html +='<br><br>';
        html +='        <p><b>Place Name :<br> </b>'+details.image_place_name+'</p>';
        html +='        <p><b>Description :<br> </b>'+details.description+'</p>';
        html +='        <p><b>Created Date :<br> </b>'+details.created_at+'</p>';
        html +='    </div>';
        html +='     </div>';

    $('#model_body_iamge').html(html);
    $('#exampleModalScrollable').modal('show');
    
});

function filter(){

    var formData = new FormData();
    formData.append('search' , $('#search').val());
    formData.append('status' , $("#users-list-status").val());

    $.ajax({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        },
        type:'POST',
        url:'/filter/status',
        data:formData,
        processData: false,
        contentType: false,
        success: function(response) {
            console.log(response);
            var html = '';
            if(response.success == '1'){
                all_images_data=response.data;
                $('#img-container').html('');
                if(response.data.length > 0){
                    response.data.forEach(element => {
                      html +=     '<div class="item img-grid">';
                      html +=   '<img src=" '+(element.image == null  ? '/no-image.svg' : '/images/'+element.image+'')+' " data-id='+element.id+' class="image_popup" style= "height:150px; width:100%; object-fit:cover;">';
                      html +=  ' <p class="sender-name name_str"><i class="bx bx-send"></i>';
                      html +=      ' Sent:'+element.sender+' '+element.sender_last+' ';
                      html +=    '</p>';
                      html +=  ' <p class="sender-name name_str"><i class="bx bx-send"></i>';
                      html +=     ' Receiver: '+element.receiver+' '+element.receiver_last+' ' ;
                      html +=   '</p>';
                      html +=    ' <p class="sender-name name_str"><i class="bx bxs-calendar"></i>'+element.created_at+' </p><br>';
                      

                    if (element.status == 11) {
                        
                        html +=   "<span class='badge badge-light-warning' style='padding: 0.25rem 0.45rem;'>Pending</span>";
                    }
                    if (element.status == 12) {
                        html +=   "<span class='badge badge-light-info' style='padding: 0.25rem 0.45rem;'>Confirm</span>";
                    }
                    if (element.status == 13) {
                        html +=   "<span class='badge badge-light-success' style='padding: 0.25rem 0.45rem;'>Completed</span>";
                    }
                    if (element.status == 14) {
                        html +=   "<span class='badge badge-light-danger' style='padding: 0.25rem 0.45rem;'>Rejected</span>";
                    }
                    html +=  '<a href="" data-id="'+element.id+'" class="float-top remove-image"><i class="bx bx-trash bx-sm"></i></a>';     
                      html +=   '</div>';
        
                    });
                    $('#img-container').append(html);
                }
                else{
                    var html = '';
                    html +=  '<p class="text-bold-1000"> <b>No data found.</b>  </p>';
                   
                    $('#img-container').append(html);
                   
                }
            }
        },
        error:function(jqXHR, textStatus, ex){ 
           
        console.log(jqXHR.responseText);
           
        }
    });
}