function fetchUserDetails() {
    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        data: {x:1},
        dataType: 'json' ,
        success: function(userDetails) {
            $('#new_usr').val(userDetails.username);
            $('#email').val(userDetails.email);
            document.getElementById("score").textContent =(userDetails.score);
            document.getElementById("tokens").textContent =(userDetails.tokens);
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
    var new_password=$("#new_pwd").val();
    var act = "update";
    
    if( old_password ==''){
        alert("Please fill out your password");
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

function generateOffersHistory(offers) {
    var html = '<table>';
    html +='<h2>Προσφορές</h2>';
    html += '<tr><th></th><th>Κατάστημα</th><th>Προϊόν</th><th>Τιμή</th><th>Ημερομηνία</th></tr>';
    
    for (var i = 0; i < offers.length; i++) {
        html += '<tr>';
        html += '<td>' + (i + 1) + '</td>';
        html += '<td>' + offers[i].store_name + '</td>';
        html += '<td>' + offers[i].product_name + '</td>';
        html += '<td>' + offers[i].price + '€</td>'
        html += '<td>' + offers[i].date + '</td>';
        html += '</tr>';
    }
    
    html += '</table>';
    return html;
}


function fetchUserOffers() {
    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        data: {x:2},
        dataType: 'json' ,
        success: function(userOffers) {
            var OffrersHtml = generateOffersHistory(userOffers);
            $('#offers').html(OffrersHtml);
        },
        error: function(xhr, status, error) {
            console.error(xhr, status, error);
        }
    });
}

function RatingsHistory(ratings){
    var html = '<table>';
    html +='<h2>Αξιολογήσεις</h2>';
    html += '<tr><th></th><th>Προϊόν</th><th>Τιμή</th><th>Χρήστης</th><th>Αντίδραση</th><th>Ημερομηνία</th></tr>';
    
    for (var i = 0; i < ratings.length; i++) {
        html += '<tr>';
        html += '<td>' + (i + 1) + '</td>';
        html += '<td>' + ratings[i].name + '</td>';
        html += '<td>' + ratings[i].price + '</td>';
        html += '<td>' + ratings[i].username + '</td>';
        if(ratings[i].react == 1){
            html += '<td style="color: red">' + "<i style='color: red' class = 'fa fa-thumbs-down fa-lg' ></i> " + '</td>';
        }
        else if(ratings[i].react == 2){
            html += '<td>' + "<i style='color: blue' class = 'fa fa-thumbs-up fa-lg' ></i> " + '</td>';
        }
        html += '<td>' + ratings[i].timestamp + '</td>';
        html += '</tr>';
    }
    
    html += '</table>';
    return html;
}


function fetchUserRatings() {
    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        data: {x:3},
        dataType: 'json' ,
        success: function(userRatings) {
            var RatingsHtml = RatingsHistory(userRatings);
            $('#ratings').html(RatingsHtml);
        },
        error: function(xhr, status, error) {
            console.error(xhr, status, error);
        }
    });
}


function fetchUserPoints(){
    var totScoreElement = document.getElementById("tot-score");
    var lmScoreElement = document.getElementById("cm-score");
    var totTokensElement = document.getElementById("tot-tokens");
    var lmTokensElement = document.getElementById("lm-tokens");

    $.ajax({
        url: '../php/user_info.php',
        type: 'POST',
        data: {x:4},
        dataType: 'json' ,
        success: function(userPoints) {
            console.log(userPoints);
            totScoreElement.textContent = (userPoints.score  );
            lmScoreElement.textContent = (userPoints.cm_score !== null ? userPoints.cm_score : 0 );
            totTokensElement.textContent = (userPoints.tokens);
            lmTokensElement.textContent =(userPoints.lm_tokens !== null ? userPoints.lm_tokens : 0);
        },
        error: function(xhr, status, error) {
            console.error(xhr, status, error);
        }
    });
}
 
  