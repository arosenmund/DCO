# DCO
## All Current Scripts below are located in the SCRIPTS folder.
*** To use them open and read the instructions in the comments at the top of file. ***

## Power-SCAN - located in the scripts folder runs indpendnetly

Scan common ports of every endpoint of a give subnet.  In progress to build out enumberation of adjacent networks by hop for additional enumeration and scanning. ~this is the most defeloped and actively worked on, hence the change in the structure.  I am planning on starting here working toward having this become a continuous monitoring tool that checks for changes in assets and alerts accordingl, and then moving to the others.

## Domain_File_Search.ps1

Searches through sysvol on your domain for passwords, files, usernames and anything else that may be erroneously stored in a publicly readable space.


## Native AD-SCAN

Domain Active directory queries from powershell using native .net libraries only for ldap connections.  No need for the installation fo the ad module by the admin.  Enumeration station.




## Site-Check

Monitors the delay, ttl, route and dns of a website in real time.  Check through the code notes to make it work for your specific environment.  Good to know if your route changes...or if the dns is suddenly different, can be a indicator of an outage or malicous intent.
