# kissbp
(Keep it Simple Stupid Bash Prompt Styler)

---

### __about__  
I can't seem to catch a break. There's always something preventing me from running zsh. So here's a stupid simple styler when zsh isn't an option.

### __howto__

Requirements

* Must have jq installed (e.g. sudo apt install jq)
* Must being running terminal supporting 256 color

Setup

1. Run "kissbp_colors.sh" script to find color id of interest for the foreground and background. (Tip) Choose 0 if you don't want a background color.
2. Open up config file "kissbp.json" and add your color id(s) from step above. Change anything else you want at this time.
3. Stuff "kissbp.sh" in your home directory
4. At end of ".bashrc" source the "kissbp.sh" script
      e.g.
      source $HOME/kissbp.sh 
5. Profit and go grab some coffee
