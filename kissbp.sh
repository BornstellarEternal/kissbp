#!/bin/bash

conf="$HOME/kissbp.json"

UN_FG="38;5;$( jq -r        .username_fg_color ${conf} )m"
UN_BG="\e[48;5;$( jq -r     .username_bg_color ${conf} );"

UH_SEP_FG="38;5;$( jq -r    .userhost_sep_fg_color ${conf} )m"
UH_SEP_BG="\e[48;5;$( jq -r .userhost_sep_bg_color ${conf} );"

HN_FG="38;5;$( jq -r        .hostname_fg_color ${conf} )m"
HN_BG="\e[48;5;$( jq -r     .hostname_bg_color ${conf} );"

BC_FG="38;5;$( jq -r        .git_branch_fg_color ${conf} )m"
BC_BG="\e[48;5;$( jq -r     .git_branch_bg_color ${conf} );"

CD_FG="38;5;$( jq -r        .pwd_fg_color ${conf} )m"
CD_BG="\e[48;5;$( jq -r     .pwd_bg_color ${conf} );"

IP_FG="38;5;$( jq -r        .ip_fg_color ${conf} )m"
IP_BG="\e[48;5;$( jq -r     .ip_bg_color ${conf} );"

DT_FG="38;5;$( jq -r        .datetime_fg_color ${conf} )m"
DT_BG="\e[48;5;$( jq -r     .datetime_bg_color ${conf} );"

PP_FG="38;5;$( jq -r        .prompt_symbol_fg_color ${conf} )m"
PP_BG="\e[48;5;$( jq -r     .prompt_symbol_bg_color ${conf} );"

SYMBOL_1="$( jq -r          .symbol_1 ${conf} )"
SYMBOL_2="$( jq -r          .symbol_2 ${conf} )"

R="\e[0m"
u_tmp="Bornstellar"
h_tmp="Forerunner"
function setup_user_hostname_labeling ()
{
	userlabel="${UN_BG}${UN_FG}${u_tmp}${R}"
	seprlabel="${UH_SEP_BG}${UH_SEP_FG}${SYMBOL_2}${R}"
	hostlabel="${HN_BG}${HN_FG}${h_tmp}${R}"
	userhostlabel="${userlabel}${seprlabel}${hostlabel}"
}

function setup_git_labeling ()
{
    SB_N="$(git symbolic-ref --short HEAD 2>/dev/null)"
    gitbranchlabel="${BC_BG}${BC_FG}${SB_N}${R}"		
}

function setup_prompt_labeling ()
{
	promptlabel="${PP_BG}${PP_FG}${SYMBOL_1}${R}"
}

function setup_pwd_labeling ()
{
    currentdirlabel="${CD_BG}${CD_FG}[ \w ]${R}"
}

function setup_ip_labeling ()
{
    ipaddresslabel="${IP_BG}${IP_FG}$(hostname -I | awk '{print $1}')${R}"
}

function setup_datetime_labeling ()
{
    datetimelabel="${DT_BG}${DT_FG}$(date +%D)${R}"
}

function prompt_command ()
{
    setup_user_hostname_labeling
    setup_prompt_labeling
    setup_git_labeling
    setup_pwd_labeling
    setup_datetime_labeling
    setup_ip_labeling

	KISSBP_BPPROMPT_PROMPT="${promptlabel}"
	KISSBP_USERHOST_PROMPT="${userhostlabel}"
	KISSBP_CURRENTDIR_PROMPT="${currentdirlabel}"
	KISSBP_GITBRANCH_PROMPT="${gitbranchlabel}"
    KISSBP_DATETIME_PROMPT="${datetimelabel}"
    KISSBP_IPADDR_PROMPT="${ipaddresslabel}"

    # (WARNING) - Do not change indention of export statement
    # (WARNING) - Do not use "\n" characters either
    # Arrange KISSBP* prompt variables as you wish

export PS1="
${KISSBP_CURRENTDIR_PROMPT}  ${KISSBP_GITBRANCH_PROMPT}
${KISSBP_BPPROMPT_PROMPT}"
}
export PROMPT_COMMAND=prompt_command
