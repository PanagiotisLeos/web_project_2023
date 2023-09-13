
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
