// Function to populate the form fields with user details
function fetchUserDetails() {
    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        dataType: 'json' ,
        success: function(userDetails) {
            $('#new_usr').val(userDetails.username);
            $('#email').val(userDetails.email);
        },
        error: function(xhr, status, error) {
            console.error(xhr, status, error);
        }
    });
}

$("#edit_form").on("submit" , function (event) {
    event.preventDefault();
    var username = $("#new_usr").val();
    var old_password=$("#old_pwd").val();
    var new_password=$("#old_pwd").val();
    var act = "update";
    
    if( old_password ==''){
        alert("Please fill all fields...!!!!!!");
    } else {
        $.post("../php/edit.php", {action: act, username: username , old_password: old_password, new_password: new_password }, function(res){
            if(res == 1) {
            alert("changes saved successfully");
            $('#edit_form')[0].reset();
            fetchUserDetails();
            }
            else{
                alert("wrong password");
            }
    });

    }
});


/*function populateFormWithUserDetails() {
    fetchUserDetails()
        .done(function (userDetails) {
            alert(JSON.stringify(userDetails, null, 2));
            $('#new_usr').val("userDetails.username");
            $('#email').val(userDetails.email);
            // Update other form fields with user details as needed
        })
        .fail(function (error) {
            console.error(error);
            // Handle error, e.g., show an error message to the user
        });
}*/








 
  