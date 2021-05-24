
(function (window) {
    'use strict';
   
    /*
 * Log application events for analytics usage.
 * @param string event The event name.
 * @param object data The event params.
 */

    window.showSuccessMessage = function(title='', sub_title=''){
    
        toastr.options =
        {
            "closeButton" : true,
        }
        toastr.success(title, sub_title);
    }


    window.showErrorMessage = function(title='', sub_title=''){
    
        toastr.options =
        {
            "closeButton" : true,
        }
        toastr.error(title, sub_title);
    
    }
      
    window.hideLoadingDialog = function(){
    
        loadingDialogToast.close();  
    
    }
    window.confirmDialogMessage = function(title_msg, sub_title_msg, furtherFuntionToCall,target = ''){
  
        Swal.fire({
           
            title: title_msg,
            text: sub_title_msg,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Ok',
            target: (target !='' ? document.getElementById(target) : 'body'),
        }).then((result) => {
    
            if (result.value) {
    
                furtherFuntionToCall();
    
            }
            
        });
    
    }

    window.submitForm = function (selector, options){
       
        $(selector).validate({
            rules : options.rules ? options.rules : {},
            messages : options.messages ? options.messages : {},
            submitHandler: function(form, event) {
                
                event.preventDefault();
                
                form.submit();
            }
        });

    }

  
       window.getDetailsFromObjectByKey = function(obj, id, key){
   
        for (var data in obj) {
            var e = obj[data];
            if (e[key] == id) {
                return e;
            }
        }
    };
}(window));
