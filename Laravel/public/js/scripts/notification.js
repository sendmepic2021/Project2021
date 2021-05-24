
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
$(document).ready(function () {

    // variable declaration
    var usersTable;
    // datatable initialization
    if ($("#notification-list-datatable").length > 0) {
        usersTable = $("#notification-list-datatable").DataTable({
            // responsive: true,
            // 'columnDefs': [
            //     {
            //         "orderable": true,
            //         "targets": [5]
            //     }]
        });
    };

}); 
$("#TypeSelect").change(function(){
    var notificationtype = $("#TypeSelect option:selected").val();
    
    if(notificationtype == '16'){
        $(".hide").show();
    }else{
        $(".hide").hide();
    }
});

if ($("#noti-users-select2").length > 0) {
    $("#noti-users-select2").select2({
        dropdownAutoWidth: true,
        width: '100%'
    });
}
