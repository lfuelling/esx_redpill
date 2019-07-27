$(function () {
    var term;
    window.addEventListener('message', function (event) {
        if (event.data.type === "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";

            if (event.data.enable) {
                term = $('#screen').terminal(function (command, term) {
                    term.pause();
                    $.post('http://esx_redpill/command', {command: command, machine: event.data.machine});
                    term.resume();
                }, {
                    greetings: 'Welcome to Redpill OS v0.1',
                    prompt: event.data.machine.user + '@' + event.data.machine.hostname + ' $ '
                });
                console.log('Terminal initialized.')
            } else {
                term = undefined;
                console.log('Terminal removed.')
            }
        } else if(event.data.type === "terminalOut") {
            console.log('terminalOut received!');
            if(term !== undefined) {
                console.log('printing: \'' + event.data.output + '\'');
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