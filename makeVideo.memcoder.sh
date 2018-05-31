ls -1v | grep image > files.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=21600000 -o timelapse.0.avi -mf  type=jpeg:fps=24 mf://@files.txt -vf scale=1920:1080

ls -1v | grep pass1 > files.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=21600000 -o timelapse.pass.1.avi -mf type=jpeg:fps=24 mf://@files.txt -vf scale=1920:1080

ls -1v | grep pass2 > files.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=21600000 -o timelapse.pass.2.avi -mf type=jpeg:fps=24 mf://@files.txt -vf scale=1920:1080

ls -1v | grep pass3 > files.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=21600000 -o timelapse.pass.3.avi -mf type=jpeg:fps=24 mf://@files.txt -vf scale=1920:1080

ls -1v | grep pass4 > files.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=21600000 -o timelapse.pass.4.avi -mf type=jpeg:fps=24 mf://@files.txt -vf scale=1920:1080
