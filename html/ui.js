$(function () {
    var term;
    window.addEventListener('message', function (event) {
        if (event.data.type === "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";

            if (event.data.enable) {
                term = $('#screen').terminal(function (command, term) {
                    if (command === "exit") {
                        $.post('http://esx_redpill/escape', JSON.stringify({}));
                    } else {
                        term.pause();
                        $.post('http://esx_redpill/command', JSON.stringify({
                            command: command,
                            machine: event.data.machine
                        }));
                        term.resume();
                    }
                }, {
                    greetings: 'Welcome to Redpill OS v0.1',
                    prompt: event.data.machine.user + '@' + event.data.machine.hostname + ' $ '
                });
            } else {
                term.purge();
            }
        } else if (event.data.type === "terminalOut") {
            console.log('terminalOut received!');
            if (term !== undefined) {
                term.echo(event.data.output);
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