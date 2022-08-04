#  Description

A minimal viable Mac App allows changing Razer BlackWidow V3 Mini effect to static white automatically via Bluetooth mode, so I do not have to press fn + ctrl + 2 four times every time when switching back from Windows OS. 

# How to use

1. Check Bluetooth in Signing & Capabilities  -> App Sandbox
2. Add Privacy - Bluetooth Always Usage Description key in Info Property List
3. Build from the source code and launch the App. 
4. Switch off the Bluetooth mode and turn it on after launching the App.

# Tools

[Wireshark](https://www.wireshark.org/) is used to find the device hex value

[Bluetility](https://github.com/jnross/Bluetility) is used to find device address and service UUID and it also allows me to change the value for quick testing.

# Device Reference

Address:

7C2FD6EE-9CE5-BE29-D355-63A85CF2BA49

Service UUID:

52401524-f97c-7f90-0e7f-6c6f4e36db1c

Set state command hex value:

130a000010030000

Wave effect hex value

04022800000000000000


Static white effect hex value
01000001ffffff000000


Breathe effect hex value

0200000100ff00000000

Reactive effect hex value

0500030100ff00000000

Cycle effect hex value

03000000000000000000

Color ref.:

white: ffffff

green: 00ff00




