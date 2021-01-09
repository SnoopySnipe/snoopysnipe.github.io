(function() {
    "use strict";
    window.onload = function(){
        
        document.querySelector("#teaching_tab").addEventListener('click', function(e){
            let teaching_options = document.querySelector("#teaching_options");
            if (teaching_options.style.display == "none") {
                teaching_options.style.display = "";
            } else {
                teaching_options.style.display = "none";
            }
        });
        
    };
}());