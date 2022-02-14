#!/bin/bash

# configuration file
conf="$HOME/kissbp.json"

# extract foreground and background colors using jq from config
UN_FG="38;5;$( jq -r .kissbp_username_fg_color ${conf} )m"
UN_BG="\e[48;5;$( jq -r .kissbp_username_bg_color ${conf} );"

HN_FG="38;5;$( jq -r .kissbp_hostname_fg_color ${conf} )m"
HN_BG="\e[48;5;$( jq -r .kissbp_hostname_bg_color ${conf} );"

BD_FG="38;5;$( jq -r .kissbp_dirty_gb_fg_color ${conf} )m"
BD_BG="\e[48;5;$( jq -r .kissbp_dirty_gb_bg_color ${conf} );"

BC_FG="38;5;$( jq -r .kissbp_clean_gb_fg_color ${conf} )m"
BC_BG="\e[48;5;$( jq -r .kissbp_clean_gb_bg_color ${conf} );"

CD_FG="38;5;$( jq -r .kissbp_curr_dir_fg_color ${conf} )m"
CD_BG="\e[48;5;$( jq -r .kissbp_curr_dir_bg_color ${conf} );"

IP_FG="38;5;$( jq -r .kissbp_ip_fg_color ${conf} )m"
IP_BG="\e[48;5;$( jq -r .kissbp_ip_bg_color ${conf} );"

DT_FG="38;5;$( jq -r .kissbp_datetime_fg_color ${conf} )m"
DT_BG="\e[48;5;$( jq -r .kissbp_datetime_bg_color ${conf} );"

PP_FG="38;5;$( jq -r .kissbp_bpprompt_fg_color ${conf} )m"
PP_BG="\e[48;5;$( jq -r .kissbp_bpprompt_bg_color ${conf} );"

UH_SEP_FG="38;5;$( jq -r .kissbp_userhost_sep_fg_color ${conf} )m"
UH_SEP_BG="\e[48;5;$( jq -r .kissbp_userhost_sep_bg_color ${conf} );"

# extract other misc settings from config
PP_SYMBOL_LOOK="$( jq -r .kissbp_bpprompt_sym_look ${conf} )"
UH_SEPERA_LOOK="$( jq -r .kissbp_userhost_sep_look ${conf} )"

ENABLE_SPECIAL_BRANCH_BLK="$( jq -r .kissbp_enable_special_branch_blinking ${conf} )"
ENABLE_SPECIAL_BRANCH_FMT="$( jq -r .kissbp_enable_special_branch_formatting ${conf} )"
ENABLE_SPECIAL_BRANCH_MSG="$( jq -r .kissbp_enable_special_branch_message ${conf} )"
SPECIAL_CLEAN_BRANCH_MSG="$( jq -r .kissbp_special_clean_branch_message ${conf})"
SPECIAL_DIRTY_BRANCH_MSG="$( jq -r .kissbp_special_dirty_branch_message ${conf} )"
SPECIAL_BRANCH_NME="$( jq -r .kissbp_special_branch_name ${conf} )"

ENABLE_SPECIAL_DIR_BLK="$( jq -r .kissbp_enable_special_dir_blinking ${conf} )"
ENABLE_SPECIAL_DIR_FMT="$( jq -r .kissbp_enable_special_dir_formatting ${conf} )"


#   a "reset all attributes" shortcut for ending a label, all labels 
#   must end with this so a new label can be applied
R="\e[0m"
#R=""

#   funct   git_branch_info
#   about   a quick way to extract name of current branch and remove 
#           characters (e.g. spaces, "*")
function git_branch_info ()
{
    local gbi=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
    echo "${gbi}" | sed 's/ //g'
}

#   funct   setup_user_hostname_labeling
#   about   setup the label for how a username, seperator and hostname
#           label should look. any type of dynamic animation/formatting
#           should be done in this function.
function setup_user_hostname_labeling ()
{
	# configuration of username, seperator and hostname animation/formatting
	userlabel="${UN_BG}${UN_FG}\u${R}"
	seprlabel="${UH_SEP_BG}${UH_SEP_FG}${UH_SEPERA_LOOK}${R}"
	hostlabel="${HN_BG}${HN_FG}\h${R}"
	userhostlabel="${userlabel}${seprlabel}${hostlabel}"
}

#   funct   setup_git_labeling
#   about   setup the label for how a git branch should look on the
#           prompt. any type of dynamic animation/formatting
#           should be done in this function.
function setup_git_labeling ()
{
	# configuration of git animation/formatting
	if git rev-parse --git-dir > /dev/null 2>&1; then
        
        SB_N="$(git_branch_info)"
		
        # apply color if clean (and special msg if special branch)
		if output=$(git status --porcelain) && [ -z "$output" ]; then

            if [[ "${SB_N}" == "(${SPECIAL_BRANCH_NME})" ]]; then
                gitbranchlabel="${BC_BG}${BC_FG}${SB_N} ${SB_CM}${R}"
            else
                gitbranchlabel="${BC_BG}${BC_FG}${SB_N}${R}"
            fi

        # apply color if dirty (and special settings if special branch)
        else

			# apply blinking animation if supported
            if [[ "${SB_N}" == "(${SPECIAL_BRANCH_NME})" ]]; then
				gitbranchlabel="${BD_BG}${BD_FG}${SB_B}${SB_F}${SB_N} ${SB_DM}${R}"
            else
                gitbranchlabel="${BD_BG}${BD_FG}${SB_N}${R}"
            fi

		fi
	else
		gitbranchlabel=""
	fi
}

#   funct   setup_prompt_labeling
#   about   setup the prompt for how it should look. any type
#           of dynamic animation/formatting should be done done
#           in this function
function setup_prompt_labeling ()
{
    # configuration of prompt animation/formatting
	promptlabel="${PP_BG}${PP_FG}${PP_SYMBOL_LOOK}${R}"
}

#   funct   setup_pwd_labeling
#   about   setup how the current working directory should
#           look. any type of dynamic animation/formatting
#           should be done in this function. It appears 
#           some terminal emulators do not support blinking
#           and so blinking may not work in some terminals.
#           I'm going to add underlining here as an additional
#           feature when blinking doesn't work for now.
function setup_pwd_labeling ()
{
    # configuration of special directory animation/formatting
    if [[ $PWD/ = /mnt/* || $PWD = / ]]; then
		currentdirlabel="${CD_BG}${CD_FG}[ ${SB_B}${SB_F}\w${R} ]"
    else
        currentdirlabel="${CD_BG}${CD_FG}[ \w${R} ]"
	fi
}

function setup_ip_labeling ()
{
    ipaddresslabel="${IP_BG}${IP_FG}$(hostname -I | awk '{print $1}')${R}"
}

function setup_datetime_labeling ()
{
    datetimelabel="${DT_BG}${DT_FG}$(date +%D)${R}"
}
#   funct   prompt_command
#   about   the main event. call all the above *labeling functions
#           here to set things up. All *labeling functions should
#           appear before the *_PROMPT variables are set. Also 
#           any type of preconfiguration (such as acting on any 
#           conditional circumstances from the config file) should
#           be done at the beginning.
function prompt_command ()
{
    # place all preconfiguration logic here

    # preconfiguration of git animation/formatting

    if [[ "${ENABLE_SPECIAL_BRANCH_BLK}" == "true" ]]; then
	    SB_B="\e[5m"
    else
	    SB_B=""
    fi
    if [[ "${ENABLE_SPECIAL_BRANCH_FMT}" == "true" ]]; then
        SB_F="\e[4m"
    else
        SB_F=""
    fi
    if [[ "${ENABLE_SPECIAL_BRANCH_MSG}" == "true" ]]; then
        SB_DM="${SPECIAL_DIRTY_BRANCH_MSG}"
        SB_CM="${SPECIAL_CLEAN_BRANCH_MSG}"
    else
        SB_M=""
    fi

    # preconfiguration of special directory animation/formatting
    if [[ "${ENABLE_SPECIAL_DIR_BLK}" == "true" ]]; then
        SD_B="\e[5m"
    else
        SD_B=""
    fi
    if [[ "${ENABLE_SPECIAL_DIR_FMT}" == "true" ]]; then
        SD_F="\e[4m"
    else
        SD_F=""
    fi

    # place all *labeling functions here
    setup_user_hostname_labeling
    setup_prompt_labeling
    setup_git_labeling
    setup_pwd_labeling
    setup_datetime_labeling
    setup_ip_labeling

    # place/initialize all *_PROMPT variables here
	KISSBP_BPPROMPT_PROMPT="${promptlabel}"
	KISSBP_USERHOST_PROMPT="${userhostlabel}"
	KISSBP_CURRENTDIR_PROMPT="${currentdirlabel}"
	KISSBP_GITBRANCH_PROMPT="${gitbranchlabel}"
    KISSBP_DATETIME_PROMPT="${datetimelabel}"
    KISSBP_IPADDR_PROMPT="${ipaddresslabel}"

    # (WARNING) - Do mess with the indention of export statement
    # (WARNING) - Do not use "\n" characters
    # Move the KISSBP_* variables around where you want them

# example 1 in readme
#export PS1="
#${KISSBP_USERHOST__PROMPT}
#${KISSBP_CURRENTDIR_PROMPT} ${KISSBP_BPPROMPT_PROMPT}"

# example 2 in readme
export PS1="
${KISSBP_IPADDR_PROMPT}
${KISSBP_GITBRANCH_PROMPT}
${KISSBP_CURRENTDIR_PROMPT}
${KISSBP_BPPROMPT_PROMPT}"
#export PS1="
#${KISSBP_USERHOST_PROMPT} ${KISSBP_IPADDR_PROMPT} ${KISSBP_DATETIME_PROMPT} ${KISSBP_GITBRANCH_PROMPT}
#${KISSBP_CURRENTDIR_PROMPT}
#${KISSBP_BPPROMPT_PROMPT}"
}

export PROMPT_COMMAND=prompt_command
