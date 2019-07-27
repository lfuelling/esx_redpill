$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type === "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";

            if(event.data.enable) {
                $('#screen').terminal(function (command, term) {
                    term.pause();
                    $.post('http://esx_redpill/command', {command: command, machine: event.data.machine}, function (response) {
                        if(response.result) {
                            term.echo(response.print).resume();
                        } else {
                            term.echo("Error: " + response.print).resume();
                        }
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