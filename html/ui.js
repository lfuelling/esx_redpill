$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type === "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";

            if (event.data.enable) {
                $('#screen').terminal(function (command, term) {
                    term.pause();
                    $.ajax('http://esx_redpill/command', {
                        accept: '*',
                        data: {command: command, machine: event.data.machine},
                        method: 'POST'
                    }).done(function (data, status, req) {
                        if (data.result) {
                            term.echo(data.print);
                        } else {
                            term.echo("Error: " + data.print);
                        }
                    }).fail(function (req, status, err) {
                        term.echo('An error occurred!');
                    }).always(function () {
                        term.resume();
                    });
                }, {
                    greetings: 'Welcome to Redpill OS v0.1',
                    prompt: event.data.machine.user + '@rpos $ '
                });
            }
        }
    });

    $(document).keydown(function (e) {
        // ESCAPE key pressed
        if (e.keyCode === 27) {
            $.post('http://esx_redpill/escape', JSON.stringify({}));
        }
    });
});