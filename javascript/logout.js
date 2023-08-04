$("#logout").on("click" ,function () {
    $.get("../php/logout.php", function (res) {
      window.location.href = "login.html";
    });
  });