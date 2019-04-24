# service.irserver

LibreELEC service AddOn for the IRTrans irserver. 

## Overview

This service add-on allows Kodi to receive the IR remote commands with
some HTPC cases like the Zalman HD160, OrigenAE S16V, etc. It also
provides the irtrans "driver" for the lcdd service.

## Details

During the build of this addon, the IRTrans irserver is downloaded
from http://www.irtrans.de/en/download/linux.php, patched to be
compatible with Kodi and then packaged with a udev rule and 2 systemd
services.

The 2 systemd services are:

  - service.irservice: runs the irserver process, The irserver process
    reads from /dev/irtrans0 which is created through the udev
    rule. It sends IR remote presses on the /run/lirc/lircd.irtrans
    socket.
	
  - irserver-lircd-uinput: forwards the touch presses as kernel uinput
    events and add _EVUP events to indicate touch press releases. This
    uses the lircd-uinput process and as such allows this addon to
    co-exists with standard lirc daemon. 
	
## Installation

At this time, you need to compile this addon as part of the LibreELEC
source tree. 

The easiest way is to clone 

See this documentation: https://wiki.libreelec.tv/compile#compile_add-ons

The produced zip file can them be scp'ed to your LibreELEC
installation and use the "Install From Zip" option from within Kodi:
https://kodi.wiki/view/HOW-TO:Install_add-ons_from_zip_files

## Development

This is known to work on a Zalman HD160 case with a MCE remote and the
9.1 LibreELEC source tree but is still considered very
experimental. See TODO file for issues and work items that requires
work.
