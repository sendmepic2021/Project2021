
$(document).ready(function(){
    $('.js-switch').change(function () {
        let is_active = $(this).prop('checked') === true ? 1 : 0;
        let id = $(this).data('id');

        $.ajax({
            type: "GET",
            url: "/status/update",
            data: {'is_active': is_active, 'id': id},
            success: function (data) {
                console.log(data.message);
            }
        });
    });
});