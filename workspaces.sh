#!/bin/bash
hyprctl dispatch workspace $(( $1 + ( $( hyprctl monitors -j|jq '.[]|select(.focused)|.id' ) * $2 ) )) 
