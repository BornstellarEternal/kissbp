#!/bin/bash

# colors
conf="$HOME/kissbp.json"
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
PP_FG="38;5;$( jq -r .kissbp_bpprompt_fg_color ${conf} )m"
PP_BG="\e[48;5;$( jq -r .kissbp_bpprompt_bg_color ${conf} );"
UH_SEP_FG="38;5;$( jq -r .kissbp_userhost_sep_fg_color ${conf} )m"
UH_SEP_BG="\e[48;5;$( jq -r .kissbp_userhost_sep_bg_color ${conf} );"

# symbols and stuff
PP_SYMBOL_LOOK="$( jq -r .kissbp_bpprompt_sym_look ${conf} )"
UH_SEPERA_LOOK="$( jq -r .kissbp_userhost_sep_look ${conf} )"
BLINKING="$( jq -r .kissbp_disable_blinking ${conf} )"
BLINKING_BRANCH="$( jq -r .kissbp_blinking_branch ${conf} )"


# shortcut to reset attributes
R="\e[0m"


function git_branch_info ()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


function prompt_command ()
{
	# Determine if user wants blinking enabled
	if [[ "${BLINKING}" == "false" ]]; then
		B="\e[5m"
	else
		B=""
	fi

	# todo: apply dynamic formatting/coloring userhost
	userlabel="${UN_BG}${UN_FG}\u${R}"
	seprlabel="${UH_SEP_BG}${UH_SEP_FG}${UH_SEPERA_LOOK}${R}"
	hostlabel="${HN_BG}${HN_FG}\h${R}"
	userhostlabel="${userlabel}${seprlabel}${hostlabel}"

	# todo: apply dynamic formatting/coloring on prompt
	promptlabel="${PP_BG}${PP_FG}${PP_SYMBOL_LOOK}${R}"

	# blink in a few locations
	if [[ $PWD/ = /mnt/* || $PWD == "/" ]]; then
		currentdirlabel="${CD_BG}${CD_FG}[ ${B}\w${R} ]"
	else
		currentdirlabel="${CD_BG}${CD_FG}[ \w${R} ]"
	fi
	
	# apply simple formatting/coloring if in a git repo
	if git rev-parse --git-dir > /dev/null 2>&1; then

		# apply color if working tree clean
		if output=$(git status --porcelain) && [ -z "$output" ]; then
			gitbranchlabel="${BC_BG}${BC_FG}$(git_branch_info)${R}"
		else

			# apply color (and blinking if enabled) if working tree dirty
			if [[ "$(git_branch_info)" == " (${BLINKING_BRANCH})" ]]; then
				gitbranchlabel="${BD_BG}${BD_FG}${B}$(git_branch_info)${R}"
			else
				gitbranchlabel="${BD_BG}${BD_FG}$(git_branch_info)${R}"
			fi
		fi
	else
		gitbranchlabel=""
	fi

	KISSBP_BPPROMPT_PROMPT="${promptlabel}"
	KISSBP_USERHOST_PROMPT="${userhostlabel}"
	KISSBP_CURRENTDIR_PROMPT="${currentdirlabel}"
	KISSBP_GITBRANCH_PROMPT="${gitbranchlabel}"

# move stuff around where you want it, don't use "\n" anywhere
export PS1="
${KISSBP_USERHOST_PROMPT}${KISSBP_GITBRANCH_PROMPT}
${KISSBP_CURRENTDIR_PROMPT}
${KISSBP_BPPROMPT_PROMPT}"
}

export PROMPT_COMMAND=prompt_command
