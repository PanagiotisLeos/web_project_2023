$("#register_form").on("submit" , function (event) {
    event.preventDefault();
    var username = $("#username").val();
    var email=$("#email").val();
    var password=$("#password").val();
    if( email =='' || password ==''){
        alert("Please fill all fields...!!!!!!");
    } else {
        $.post("../php/register.php", {username: username , email:email , password: password}, function(res){
            if(res == 1) {
                $("#alert" + res)
                .fadeIn(1200,"linear")
                .fadeOut(1200,"linear");
            alert("User created successfully");
            window.location.href = "../html/login.html"
            }
            else{
                alert("user already exists");
            }
    });

    }
});