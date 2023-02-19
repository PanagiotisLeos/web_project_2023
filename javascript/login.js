$("button#submit").click(function () {

    if ($("#email").val() == "" || $("#password").val() == "")
        $("div#ack").html("Please enter both email and password");
    else
        $.post($("#login").attr("action"),
            $("#login :input").serializeArray(),
            function (data) {
                $("div#ack").html(data);
            });
    

});


function login()
{
    var email=$("email").val();
    var password=$("password").val();
    if(email="" && pass!="")


    


$.ajax({
    type: "POST",
    url: "../php/login.php",
    data: {
        email: email,
        password: password
    },
    success: function (response) {
        if(response == "success")
        {
            window.location.href='index.php'
        }
        console.log('Login successfull');
        
    }})}