$("#login_form").on("submit" , function (event) {
    event.preventDefault();
    var email=$("#email").val();
    var password=$("#password").val();
    if( email =='' || password ==''){
        alert("Please fill all fields...!!!!!!");
    } else {
        $.post("../php/login.php" , {email:email , password: password} , function(response) { 
        
            if (response == 0) {
                alert ("Invalid Email or Password!");
            }
            else if(response == 1) {
                window.location.href = "../html/index.html";
            }

        });
    }

});

