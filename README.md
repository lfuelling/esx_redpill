# ESX REDPILL

Hacking minigame(/mission/job) featuring proper terminals with some sort of UNIX(-like) stuff running on them.

**Work in progress! This is pretty much NOT useable at this stage!**

## Dependencies

- [bob74_ipl](https://github.com/Bob74/bob74_ipl/)
- [esx_drugfarms](https://github.com/lfuelling/esx_drugfarms/)
- [es_extended](https://github.com/ESX-Org/es_extended)
- [esx_jobs](https://github.com/ESX-Org/esx_jobs)
- [esx_phone](https://github.com/ESX-Org/esx_phone)
- [Peds](https://github.com/SFL-Master/Peds) (optional)

## Installation

1. Place repo in `resources/[esx]/`
2. Add `start esx_redpill` to bottom of `server.cfg`
3. Go to Fort Zancudo's elevator (right below the UFO) to trigger mission start

## Usage

1. TBD

-------------------------

## Devnotes

As I stated above this is neither finished nor fully thought out. 
Things might change until 1.0 is released and as of right now, it's pretty much unplayable and using it only makes sense if you want to report bugs or help developing.

These devnotes are for ideas I have (ie. they are nto final). For real plans, please see the open issues on GitHub.

### Hacking

1. Get SMS to `esx_phone` to start a mission
    - "We need the open ports on this machine"
    - "Change password on this computer"
    - "Download and execute this script: $url"
    - "Connect to this IP from the computer"
    - "Send me the username logged in to this computer"
    - "What is in file $filepath"
    - etc.
1. Step in front of computer
    - help text to press interact shows
2. Press interact
    - Hacking UI shows
        - JQuery.Terminal.min.js
        - (badly) Emulates a bash
3. Do stuff requested in mission
4. Send/Get confirmation SMS
    - Some missions might be automatically detected (ie. password change)
5. Get paid
    - Gain higher rank after some missions
    - Harder missions on higher ranks(?)