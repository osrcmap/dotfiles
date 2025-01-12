#!/bin/bash

# As it says in "man 5 sway":
# The following commands cannot be used directly in the configuration file. They are expected to be used with bindsym or at runtime through swaymsg(1).

swaymsg border none 0
swaymsg default_border none 0
swaymsg default_floating_border none 0
