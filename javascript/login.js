    $("#login_button").on(click,function () {
        var email=$("#email").val();
        var password=$("#password").val();
    
        if(email!="" && password!="" ){
            $.ajax({
                type: "POST",
                url: "../php/logi.php",
                data: {
                email: email,
                password: password
                },
                cache: false,
                beforeSend:function(){
                    $('#login_button').val("Connecting...");
                },
                success: function (data) {
                    if(data)
                    {
                        $_SESSION['user_id'] = $user['id'];
                        header('Location: index.html');
                        exit;
                        window.location("../html/index.html");
                    }
                console.log('Login successfull');
    }
})
       }
       else{
        alert('Please fill all the field !');
    }
    });

    

/* var loginForm = document.getElementById("login");
var loginButton = document.getElementById("login_button");

function login() {
    e.preventDefault();
        var email=$("email").val();
        var password=$("password").val();

        if(email!="" && password!="" ){

            $.ajax({
                type: "POST",
                url: "../php/test.php",
                data: {
                email: email,
                password: password
        },
        cache: false,
        success: function (response) {
            if(response == "success")
            {
                window.location.replace("../html/index.html");
            }
            console.log('Login successfull');
        }
    })
           }
        } ; */
    