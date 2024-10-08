#!/bin/bash

# Scripted input goes as follows:
# /path/to/config-generator.sh TOTALMONITORS WORKSPACESPERMONITOR PERSISTENTWORKSPACES MONITOR1,MONITOR2,MONITOR3

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
	read -rp "How many workspaces do you want to be persistent per monitor? " PERSISTENTWORKSPACES;
	MONITORNAMES=()
	
	if [ "$WORKSPACESPERMONITOR" -gt 9 ]; then
		echo "Cannot create more than nine workspaces per monitor";
		exit;
	fi

	if [ "$PERSISTENTWORKSPACES" -gt "$WORKSPACESPERMONITOR" ]; then
		PERSISTENTWORKSPACES="$WORKSPACESPERMONITOR"
	fi
	
	for i in $(seq "$TOTALMONITORS"); do
		suffix=$(findSuffix "${i}");
		read -rp "What is the name of the ${i}${suffix} monitor? " x;
		MONITORNAMES+=("$x");
	done
	echo ""
else
	TOTALMONITORS="$1"
	WORKSPACESPERMONITOR="$2"
	PERSISTENTWORKSPACES="$3"
	IFS=, command eval 'MONITORNAMES=($4)'
fi

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
		persistent="false"
		if [ "$y" == 1 ]; then
			default="true";
		fi
		if [ "$y" -le "$PERSISTENTWORKSPACES" ]; then
			persistent="true"
		fi
		echo "workspace = $(( y + x * WORKSPACESPERMONITOR )),monitor:${MONITORNAMES[$x]},default:${default},persistent:${persistent}";
	done
	echo ""
done
