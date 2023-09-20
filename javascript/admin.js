
function lboard(){
    $.ajax({
        url: '../php/leaderboard.php', // Replace with your PHP script to fetch user data
        type: 'GET',
        dataType: 'json',
        success: function (data) {
            var leaderboardHtml = generateLeaderboardHTML(data);
            $('#leaderboard').append(leaderboardHtml);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error('AJAX Error:', errorThrown);
        }
    });
    
    function generateLeaderboardHTML(users) {
        html += '<h3>Leaderboard</h3>';
        var html = '<table>';
        html += '<tr><th>Rank</th><th>Username</th><th>Score</th><th>Tokens</th><th>Last months tokens</th></tr>';
        
        for (var i = 0; i < users.length; i++) {
            html += '<tr>';
            html += '<td>' + (i + 1) + '</td>';
            html += '<td>' + users[i].username + '</td>';
            html += '<td>' + users[i].score + '</td>';
            html += '<td>' + users[i].tokens + '</td>';
            html += '<td>+' + users[i].tokens + '</td>';
            html += '</tr>';
        }
        
        html += '</table>';
        return html;
    }
};


function delAllStores() {
    $.get("../php/store_update.php",function(response){
        if(response == 1) {
            alert("Deleted successfully")
        }
    })
  };

<<<<<<< Updated upstream
=======
  function delAllProducts() {
    
    $.get("../php/products_update.php", function (response) {
        if (response == 1) {
            alert("All products deleted successfully");
        } else {
            alert("Failed to delete products");
        }
    });
}


function delAllCategories() {

    $.get("../php/categories_update.php", function (response) {
        if (response == 1) {
            alert("All categories deleted successfully");
        } else {
            alert("Failed to delete categories");
        }
    });
}


>>>>>>> Stashed changes

  

  function populateMonths() {
    const monthSelect = document.getElementById("monthSelect");
  
    // List of months
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
  
    // Populate the month select element
    for (let i = 0; i < months.length; i++) {
      const option = document.createElement("option");
      option.value = i + 1; // Month values typically start from 1
      option.text = months[i];
      monthSelect.appendChild(option);
    }
  }
  
  // Function to populate the year select element
  function populateYears() {
    const yearSelect = document.getElementById("yearSelect");
  
    // Get the current year
    const currentYear = new Date().getFullYear();
  
    // Define a range of years (e.g., from 10 years ago to 10 years in the future)
    const startYear = currentYear - 5;
    const endYear = currentYear;
  
    // Populate the year select element
    for (let year = startYear; year <= endYear; year++) {
      const option = document.createElement("option");
      option.value = year;
      option.text = year;
      yearSelect.appendChild(option);
    }
  }

  populateMonths();
  populateYears();


function fetchDataAndRenderChart() {
    const selectedMonth = document.getElementById('monthSelect').value;
    const selectedYear = document.getElementById('yearSelect').value;

    $.ajax({
        url: '../php/graph.php', 
        type: 'GET',
        data: {x:1 , month: selectedMonth , year :selectedYear},
        dataType: 'json',
        success: function (data) {
         
          updateChart(data);
      
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error('AJAX Error:', errorThrown);
        }
    });

  }
  

function updateChart(data) {
  var labels = data.map(entry => entry.date);
  var dataPoints = data.map(entry => parseInt(entry.number_of_offers));
    
  chart.data.labels = labels;
  chart.data.datasets[0].data = dataPoints;
  chart.update();
  }

<<<<<<< Updated upstream
  document.getElementById('yearSelect').addEventListener('change', fetchDataAndRenderChart);



function delAllProducts() {
    
        $.get("../php/products_update.php", function (response) {
            if (response == 1) {
                alert("All products deleted successfully");
            } else {
                alert("Failed to delete products");
            }
        });
    }


function delAllCategories() {
    
        $.get("../php/categories_update.php", function (response) {
            if (response == 1) {
                alert("All categories deleted successfully");
            } else {
                alert("Failed to delete categories");
            }
        });
    }


function delAllSubcategories() {
    
        $.get("../php/subcategories_update.php", function (response) {
            if (response == 1) {
                alert("All subcategories deleted successfully");
            } else {
                alert("Failed to delete subcategories");
            }
        });
    }

    function delAllPrices() {
    
        $.get("../php/price_update.php", function (response) {
            if (response == 1) {
                alert("All prices deleted successfully");
            } else {
                alert("Failed to delete prices");
            }
        });
    }
=======
  document.getElementById('yearSelect').addEventListener('change', fetchDataAndRenderChart);
>>>>>>> Stashed changes
