# Run Apps Bash Script

This script allows you to configure multiple applications that you want to run simultaneously in separate tmux windows. The script will prompt you to provide the directory path of the application, the start command for the application, and the port the application runs on. It can handle multiple applications, asking you after each app if you want to add another one.

The script will generate two files:

- `rapps_config.sh`: This file will contain the configuration details of the applications that you provided during the initial setup. It includes the directory paths, the start commands, and the ports for each of your applications.

- `rapps.sh`: This script is the main executable that you will run to start your applications. It sources the configuration from `rapps_config.sh` and does the following for each app:
  - Kills any running process on the specified port.
  - Starts a new tmux session with the first app.
  - Starts a new tmux window for the remaining apps.
  - Attaches to the tmux session so you can interact with your apps.

## Usage

To use the script, run it in your terminal:

```bash
./init_script.sh
```

You will then be prompted to enter the details of your applications.

Once you have entered all your applications, you can start them by running:

```bash
./rapps.sh
```

This will start each app in a separate tmux window.

## Requirements

To run this script, you will need:

- tmux: This is a terminal multiplexer that allows multiple processes to be run in the same terminal.
- lsof: This is a command used by the script to find the process running on a particular port. 

Please make sure to install these requirements before running the script. 

This script was designed to be simple and easy to use. If you have any improvements or issues, please feel free to contribute.