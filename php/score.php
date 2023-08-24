<?php



$querry = "SELECT user_id, sum(added_score) FROM `score_history` WHERE user_id = 30 and month(timestamp) = month(CURRENT_DATE)";

$querry1 = "SELECT count(user_id) FROM user WHERE is_admin=0";




?>