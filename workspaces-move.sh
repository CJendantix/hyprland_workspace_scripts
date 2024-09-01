#!/bin/bash
hyprctl dispatch movetoworkspace $(( $1 + ( $( hyprctl monitors -j|jq '.[]|select(.focused)|.id' ) * $2 ) ))
