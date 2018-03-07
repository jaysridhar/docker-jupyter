#!/bin/bash

# Author: Jay Sridhar (jay.sridhar@gmail.com)

# The following sequence of commands were determined (after a long
# debugging session) to properly shutdown nginx and jupyter. Properly
# shutting down jupyter must be done as aurora using the "notebook
# stop" command. Just killing it (by killing the su process) results
# in this script exiting with non-zero exit code. Here, we put the su
# process starting jupyter into the background, and then wait for
# children's exit. This way, when docker sends a SIGTERM to this
# script, it can properly catch it and stop the jupyter process
# correctly.

# alter these sequence of commands only if you are prepared to 1)
# spend hours debugging it or 2) willing to tolerate unclean exit of
# jupyter and docker reporting non-zero exit status.

trap 'su -l -c "jupyter notebook stop -y" aurora; exit 0;' SIGTERM 
/usr/sbin/nginx
su -l -c 'jupyter notebook' aurora &
wait
