// Function to populate the form fields with user details
function fetchUserDetails() {
    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        dataType: 'json' ,
        success: function(userDetails) {
            $('#new_usr').val(userDetails.username);
            $('#email').val(userDetails.email);
            document.getElementById("score").textContent =(userDetails.score);
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

      // Add your JavaScript code here
      function showPage(pageId) {
        
    
          // Hide all pages
          const pages = document.querySelectorAll('.page');
          pages.forEach(page => page.classList.remove('active'));

          // Show the selected page
          const selectedPage = document.getElementById(pageId);
          if (selectedPage) {
              selectedPage.classList.add('active'); 
          }

          // Remove 'active' class from all menu buttons
        const menuButtons = document.querySelectorAll('.nav-link');
        menuButtons.forEach(button => button.classList.remove('active'));

        // Add 'active' class to the clicked menu button
        const clickedButton = document.querySelector(`[onclick="showPage('${pageId}')"]`);
        if (clickedButton) {
            clickedButton.classList.add('active');
        }
      }



function redirect(){
    let param = new URLSearchParams(document.location.search);
    const name = param.get('page');
    if (name) {
    showPage(name);
    console.log(name);
    }
}

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








 
  