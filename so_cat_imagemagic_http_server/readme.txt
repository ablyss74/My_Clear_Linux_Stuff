
###############################################################
#          Example httpd server page with ImageMagick     
#          Uses imagemagick, socat, and openssl/base64                          
#          
#          @ Add the bundle
#          sudo swupd bundle-add ImageMagick
#
#          Before executing the script you'll need to do:
#              sudo updatedb
#                                                           
#          To run, open terminal and type             
#	           bash ./index.bash   
#
#           Then
#	           Open a modern web browser to http://localhost:1234        
#	                     
#                                                             
#              Edit example.bash to change things            
#                                                             
#  
#   Technical Notes.
#
#   This is a little experiment to render encoded variables with socat
#   Small footprint and lots of power.
#   No time tracking webroot files and worrying about permissions being set or what not
#   Easy to design a really fancy looking  web site, MEME, template, banner, etc.
#   
#   The core of this script uses "version() functions as a history of previous versions.
#   Previous versions are omitted from functioning.
#
#   Add background images.
#   Renamed msg1, msg2 var to just msg.
#   Add local font to override default_font
#   Add suffix and echofont to shuffle fonts
#   Some fine tuning on how the canvas is sorted out
#   
#   Notes...
#   The way css automaticcally adjusts the canvas will be related to how many white spaces there are.
#   For examples, var "Test 123" will be a lot larger than var "   Test 123             "
#   If css=no then the above does not apply.
#
#   fontshuffle will overide local font 
#############################################################
