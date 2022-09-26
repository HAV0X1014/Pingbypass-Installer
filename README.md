# Pingbypass Installer
A script to install Pingbypass in a much more standard way compared to the "[road warrior](https://github.com/HAV0X1014/Pingbypass-Road-Warrior-Installer)" method of setup. This script assumes you have the ability to open ports or have a fully open internet connection. This script is intended for use on 2gb, 2vCPU VPS servers or above.

The only (required) dependency is `wget`. `curl` is recommended, but not required.

Sandstar Pingbypass can be found at https://discord.gg/5HVsNJrVWM

## Usage
1. Download and move the script to your VPS/VM's home directory (`~`). This script will not work elsewhere.

2. Run `bash pingbypassInstaller.sh`

3. Follow the prompts printed into the console and type your answers to each.

4. Once the script completes, login to your Minecraft account with `./hmc`, and then type `login [email]` and `password [password]`

5. Launch the server with `launch [ID of the forge install] -id`.

5.1. To relaunch the server should it crash or session expire, type `quit` to quit Minecraft, and use `./hmc` and `launch [ID of the forge install] -id`.

## Tips
Use `tmux` to create a detachable terminal session that wont end when your SSH session ends.

Use the command `tmux` to create a new session, `tmux attach` to attach to a session, and ctrl+b and then d to detach from an active session. To kill a session if you make one on accident or to end one, use `tmux kill-session`

## Credits

Same credits as the [road warrior](https://github.com/HAV0X1014/Pingbypass-Road-Warrior-Installer) install guide, since this is based on that script.

## Contributing
If you are willing to contribute, please note what you changed, what distros you tested on, and keep changes as minimal as possible.
