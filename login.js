$("button#submit").click(function () {

    if ($("#email").val() == "" || $("#password").val() == "")
        $("div#ack").html("Please enter both email and password");
    else
        $.post($("#login").attr("action"),
            $("#login :input").serializeArray(),
            function (data) {
                $("div#ack").html(data);
            });
    

});