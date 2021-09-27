#!/bin/bash

DIR=$(pwd)
BINARY="$DIR/bin/morning_brief"
LOGFILE="$DIR/logs/output.log"
CRONEXPR="0 6 * * * $BINARY 1>> $LOGFILE 2>> $LOGFILE"
(crontab -l | grep -F -v "$CRONEXPR" && echo "$CRONEXPR") | crontab -
