#!/bin/bash

# Introductory message
printf "Welcome to the Run Apps Bash Script Init Wizard.\n\nHere, you'll configure the apps which you want to start with the script.\nThe wizard will generate 'rapps.sh' and 'rapps_config.sh' files for you in the current directory.\n\nPress any key to continue."
read

# Declare arrays for the app paths, their corresponding ports, and start commands
declare -a appPaths=()
declare -a appPorts=()
declare -a startCommands=()

# While loop to get user input
while true; do
    echo "App dir path:"
    read dir_path
    appPaths+=("$dir_path")
    
    echo "App start command:"
    read start_command
    startCommands+=("$start_command")

    echo "App port:"
    read port
    appPorts+=("$port")
    
    while true; do
        echo "Would you like to configure another app? (y/n)"
        read response
        if [[ "$response" == "y" ]]; then
            break
        elif [[ "$response" == "n" ]]; then
            break 2
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    done
done

# Create rapps_config.sh file
printf "#!/bin/bash\n\n# Declare arrays for the app paths, their corresponding ports, and start commands\ndeclare -a appPaths=(\n" > rapps_config.sh
for path in "${appPaths[@]}"; do
    echo "    \"$path\"" >> rapps_config.sh
done
printf ")\n\ndeclare -a appPorts=(\n" >> rapps_config.sh
for port in "${appPorts[@]}"; do
    echo "    \"$port\"" >> rapps_config.sh
done
printf ")\n\ndeclare -a startCommands=(\n" >> rapps_config.sh
for command in "${startCommands[@]}"; do
    echo "    \"$command\"" >> rapps_config.sh
done
echo ")" >> rapps_config.sh

# Create rapps.sh file
cat << 'EOF' > rapps.sh
#!/bin/bash

# Source the config file
source ./rapps_config.sh

# Loop through the apps
for index in "${!appPaths[@]}"
do
  # Get the port and start command for the app
  port=${appPorts[$index]}
  startCommand=${startCommands[$index]}

  # Find the process ID (PID) of the process that's using the port
  pid=$(lsof -ti :$port)

  # If a process was found, kill it
  if [ ! -z "$pid" ]; then
    echo "Killing process on port $port with PID $pid"
    kill -9 $pid
  else
    echo "No process running on port $port"
  fi
done

# Create a new tmux session with the first app
tmux new-session -d -s mySession -c ${appPaths[0]} "${startCommands[0]}"

# Loop over the rest of the apps and start each one in a new tmux window
for index in $(seq 1 $((${#appPaths[@]}-1)))
do
  tmux new-window -t mySession -c ${appPaths[$index]} "${startCommands[$index]}"
done

# Attach to the tmux session
tmux attach-session -t mySession
EOF

# Make rapps.sh executable
chmod +x rapps.sh

# Final message to user
echo "The 'rapps.sh' script has been created. You can run it using './rapps.sh'. Press any key to close this wizard."
read
