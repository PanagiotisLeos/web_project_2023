$("#logout").on("click" ,function () {
    $.get("logout.php", function (res) {
      window.location.href = "login.html";
    });
  });