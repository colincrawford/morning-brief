#!/bin/bash

BINARY="$(pwd)/bin/morning_brief"
CRONEXPR="0 6 * * * $BINARY"
(crontab -l | grep -F -v "$CRONEXPR" && echo "$CRONEXPR") | crontab -
