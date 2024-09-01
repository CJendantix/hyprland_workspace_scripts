#!/bin/bash

findSuffix () {
	INPUT="$1";
	OUTPUT="";

	if [ "${INPUT: -2:1}" = 1 ]; then
		OUTPUT="th";
	else
		case ${INPUT: -1} in
			1)
				OUTPUT="st";
				;;
			2)
				OUTPUT="nd";
				;;
			3)
				OUTPUT="rd";
				;;
			*)
				OUTPUT="th";
				;;
		esac
	fi

	echo "$OUTPUT"
}

if [ ! "$1" ]; then
	read -rp "How many monitors do you have? " TOTALMONITORS;
	read -rp "How many workspaces per monitor do you want? " WORKSPACESPERMONITOR;
	read -rp "How many workspaces do you want to be persistant per monitor? " PERSISTANTWORKSPACES;
	MONITORNAMES=()
	
	if [ "$WORKSPACESPERMONITOR" -gt 9 ]; then
		echo "Cannot create more than nine workspaces per monitor";
		exit;
	fi
	
	for i in $(seq "$TOTALMONITORS"); do
		suffix=$(findSuffix "${i}");
		read -rp "What is the name of the ${i}${suffix} monitor? " x;
		MONITORNAMES+=("$x");
	done
else
	TOTALMONITORS="$1"
	WORKSPACESPERMONITOR="$2"
	PERSISTANTWORKSPACES="$3"
	MONITORNAMES=("$4")
fi
echo ""
for x in $(seq "$WORKSPACESPERMONITOR"); do
		echo "bind = SUPER, ${x}, exec, ~/.local/share/scripts/hyprland_workspace_scripts/workspaces.sh ${x} ${WORKSPACESPERMONITOR}";
done
echo ""
for x in $(seq "$WORKSPACESPERMONITOR"); do
		echo "bind = SUPER_SHIFT, ${x}, exec, ~/.local/share/scripts/hyprland_workspace_scripts/workspaces-move.sh ${x} ${WORKSPACESPERMONITOR}";
done
echo ""
for x in $(seq 0 "$(( TOTALMONITORS - 1 ))"); do
	for y in $(seq "$WORKSPACESPERMONITOR"); do
		default="false"
		persistant="false"
		if [ "$y" == 1 ]; then
			default="true";
		fi
		if [ "$y" -le "$PERSISTANTWORKSPACES" ]; then
			persistant="true"
		fi
		echo "workspace = $(( y + x * WORKSPACESPERMONITOR )),monitor:${MONITORNAMES[$x]},default:${default},persistant:${persistant}";
	done
	echo ""
done
