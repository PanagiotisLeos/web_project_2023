
function lboard(){
    $.ajax({
        url: '../php/leaderboard.php', // Replace with your PHP script to fetch user data
        type: 'GET',
        dataType: 'json',
        success: function (data) {
            // Generate and append leaderboard HTML
            var leaderboardHtml = generateLeaderboardHTML(data);
            $('#leaderboard').html(leaderboardHtml);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error('AJAX Error:', errorThrown);
        }
    });
    
    function generateLeaderboardHTML(users) {
        var html = '<table>';
        html += '<tr><th>Rank</th><th>Username</th><th>Score</th></tr>';
        
        for (var i = 0; i < users.length; i++) {
            html += '<tr>';
            html += '<td>' + (i + 1) + '</td>';
            html += '<td>' + users[i].username + '</td>';
            html += '<td>' + users[i].score + '</td>';
            html += '</tr>';
        }
        
        html += '</table>';
        return html;
    }
};
