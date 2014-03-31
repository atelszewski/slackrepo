#!/bin/bash
# Copyright 2014 David Spencer, Baildon, West Yorkshire, U.K.
# All rights reserved.  For licence details, see the file 'LICENCE'.
#-------------------------------------------------------------------------------
# logfunctions.sh - logging and web page functions for slackrepo
#   log_start
#   log_prgstart
#   log_verbose
#   log_normal
#   log_important
#   log_success
#   log_warning
#   log_error
#-------------------------------------------------------------------------------

function log_start
# Log the start of a top level item on screen and in logfile
# $* = message
# Return status: always 0
{
  msg="${*}                                                                      "
  line="==============================================================================="
  echo "$line"
  echo "! ${msg:0:66} $(date +%T) !"
  echo "$line"
  echo ""
  echo "$line"                      >>$SR_LOGFILE
  echo "STARTING $@ $(date '+%F %T')" >>$SR_LOGFILE
}

#-------------------------------------------------------------------------------

function log_prgstart
# Log the start of a sub-item on screen and in logfile.
# This is where we start logging to $prgnam.log.
# Uses $prgnam set by caller.
# $* = message
# Return status: always 0
{
  line="-------------------------------------------------------------------------------"
  tput bold; tput setaf 7
  if [ ${#1} -ge ${#line} ]; then
    echo "$@"
  else
    pad=$(( ${#line} - ${#1} - 1 ))
    echo "$@ ${line:0:$pad}"
  fi
  tput sgr0
  echo "$line"                 >>$SR_LOGFILE
  echo "$@ $(date '+%F %T')"   >>$SR_LOGFILE
  if [ -n "$prgnam" ]; then
    mkdir -p $SR_LOGDIR/${itempath%/*}
    echo "$@ $(date '+%F %T')"  >$SR_LOGDIR/$itempath.log
  fi
}

#-------------------------------------------------------------------------------

function log_verbose
# Log a message to the logfile, and also to the screen if OPT_VERBOSE is set
# (and also to $prgnam.log if '-p' is specified)
# $* = message
# Return status: always 0
{
  P='n'
  [ "$1" = '-p' ] && { P='y'; shift; }
  if [ "$OPT_VERBOSE" = 'y' ]; then
    echo "$@"
  fi
  echo "$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "$@" >>$SR_LOGDIR/$itempath.log
  return 0
}

#-------------------------------------------------------------------------------

function log_normal
# Print message on screen (unless OPT_QUIET is set), and log to logfile
# (including $prgnam.log if '-p' is specified)
# $* = message
# Return status: always 0
{
  P='n'
  [ "$1" = '-p' ] && { P='y'; shift; }
  if [ "$OPT_QUIET" != 'y' ]; then
    echo "$@"
  fi
  echo "$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "$@" >>$SR_LOGDIR/$itempath.log
  return 0
}

#-------------------------------------------------------------------------------

function log_important
# Print message on screen in white highlight, and log to logfile
# (including $prgnam.log if '-p' is specified)
# $* = message
# Return status: always 0
{
  P='n'
  [ "$1" = '-p' ] && { P='y'; shift; }
  tput bold; tput setaf 7
  echo "$@"
  tput sgr0
  echo "$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "$@" >>$SR_LOGDIR/$itempath.log
  return 0
}

#-------------------------------------------------------------------------------

function log_success
# Print message on screen in green highlight, and log to logfile
# (including $prgnam.log if '-p' is specified)
# $* = message
# Return status: always 0
{
  P='n'
  [ "$1" = '-p' ] && { P='y'; shift; }
  tput bold; tput setaf 2
  echo "$@"
  tput sgr0
  echo "$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "$@" >>$SR_LOGDIR/$itempath.log
  return 0
}

#-------------------------------------------------------------------------------

function log_warning
# Print message on screen in yellow highlight, and log to logfile
# (including $prgnam.log if '-p' is specified)
# Message is automatically prefixed with 'WARNING' (unless '-n' is specified)
# $* = message
# Return status: always 0
{
  W='WARNING: '
  P='n'
  while [ $# != 0 ]; do
    case "$1" in
    '-n') W='';  shift; continue ;;
    '-p') P='y'; shift; continue ;;
    *)    break ;;
    esac
  done
  tput bold; tput setaf 3
  echo "${W}$@"
  tput sgr0
  echo "${W}$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "${W}$@" >>$SR_LOGDIR/$itempath.log
  return 0
}

#-------------------------------------------------------------------------------

function log_error
# Print message on screen in red highlight, and log to logfile
# (including $prgnam.log if '-p' is specified)
# Message is automatically prefixed with 'ERROR' (unless '-n' is specified)
# $* = message
# Return status: always 0
{
  E='ERROR: '
  P='n'
  while [ $# != 0 ]; do
    case "$1" in
    '-n') E='';  shift; continue ;;
    '-p') P='y'; shift; continue ;;
    *)    break ;;
    esac
  done
  tput bold; tput setaf 1
  echo "${E}$@"
  tput sgr0
  # In case we are called before SR_LOGFILE is set:
  [ -z "$SR_LOGFILE" ] && return 0
  echo "${E}$@" >>$SR_LOGFILE
  [ "$P" = 'y' ] && \
  echo "${E}$@" >>$SR_LOGDIR/$itempath.log
  return 0
}
