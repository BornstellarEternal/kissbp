![](media/kissbp.png)  

# __kissbp__

(Keep it Simple Stupid Bash Prompt Styler)

---

## __about...__  

A stupid simple bash prompt with bare ass essentials.

## __howto...__

__Requirements__

* Must have jq installed (e.g. `sudo apt install jq`)
* Must be running terminal supporting 256 color

__Setup__

1. Run `kissbp_colors.sh` to choose foreground/background colors
2. Edit `kissbp.json` with colors above and/or change to desired settings
3. Stuff `kissbp.json`, `kissbp.sh` and `kissbp_colors.sh` in your home directory
4. At bottom of `.bashrc` source the `kissbp.sh` script like such...  
      `source $HOME/kissbp.sh`  
5. Reopen a new shell to apply settings or just type `source ~/.bashrc`
