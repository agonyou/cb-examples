#!/bin/bash

x=1; 
    while [ $x -lt 99 ]; 
    do ruby CB_Stats_Output.rb > stats-output.html 2>/dev/null; 
	echo "Sleeping 5 seconds"
  sleep 5; 
        echo "Polling!"
done
