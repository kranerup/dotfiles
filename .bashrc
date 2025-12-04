export EDITOR=vim
export LESS='R'
export GOPATH=$HOME/lib/go
export PATH=$GOPATH/bin:$HOME/afs/nvim-linux64/bin:$HOME/nvim-linux64/bin:$HOME/bin:$PATH
#export LS_COLORS=$LS_COLORS:'ex=0;31:'
export LS_COLORS='ex=0;31:ln=0;35'
export PATH=/opt/bin:$PATH
# this is to avoid any SE propagating from ssh if source OS was setting language
export LC_ALL=en_US.UTF-8

umask u=rwx,g=rx,o=

case "$-" in
  *i*)

      # don't put duplicate lines or lines starting with space in the history.
      # See bash(1) for more options
      HISTCONTROL=ignoreboth

      # append to the history file, don't overwrite it
      shopt -s histappend

      # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
      HISTSIZE=1000
      HISTFILESIZE=2000

      # check the window size after each command and, if necessary,
      # update the values of LINES and COLUMNS.
      shopt -s checkwinsize

      complete -r
      set -o ignoreeof
      bind '"\eb": shell-backward-word'
      bind '"\ef": shell-forward-word'
      bind '"ÿ":unix-word-rubout'
      alias ll="ls -lt --color=auto"
      alias ls="ls --color=auto"
      #function l { DISPLAY= nvim -R -X --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@" ; }
      function l { DISPLAY= nvim --cmd "let g:lessmode=1" +LessMode "$@" ; }

      alias ipy='tmux split-window "source $w/tools/tool-config.sh;ipython"'
      alias tmux='TERM=xterm-256color tmux'

      function get_display { if [[ -e $HOME/.display_ssh ]]; then cat $HOME/.display_ssh; else echo $DISPLAY; fi }
      function export_disp { export DISPLAY=$(get_display); } 
      function xdot    { (export_disp; /usr/bin/xdot $*) }
      function gitk    { (export_disp; /usr/bin/gitk $*) }
      function gnuplot { (export_disp; /usr/bin/gnuplot $*) }
      function gtkwave { (export_disp; /usr/local/bin/gtkwave $*) }
      function evince  { (export_disp; /usr/bin/evince $*) }

      function notify { tmux new-window 'whiptail --msgbox "DONE" 7 9'; }
      function withx { (export_disp; $*) }
      function withtools { (source $w/tools/tool-config.sh; $*;) }
      function tssh { ssh -R/tmp/tmux-$UID/default:/tmp/tmux-${UID}/default $*; }
      # the job run.log file
      function llogn () { 
        if [[ $1 != *.jobs ]]; then
          local runfile=$1.jobs
        else
          local runfile=$1
        fi
        local logf=$(egrep "^$2 " $runfile | col3 )
        if [[ ! -e $logf ]]; then
          if [[ -e $logf.gz ]]; then
            logf=$logf.gz
          elif [[ -e $logf.zst ]]; then
            logf=$logf.zst
          else
            echo log file $logf not found
            return
          fi
        fi
        l $logf
      }
      # the regression log file
      function llog2 () { 
        runfile=${1%%.jobs}
        logf=${runfile}/${2}.log
        if [[ ! -e $logf ]]; then
          echo log file $logf not found
          return
        fi
        l $logf
      }
      function logfn () { 
        if [[ $1 != *.jobs ]]; then
          local runfile=$1.jobs
        else
          local runfile=$1
        fi
        local logf=$(egrep "^$2 " $runfile | col3 )
        if [[ -e $logf.gz ]]; then
          logf=$logf.gz
        elif [[ -e $logf.zst ]]; then
          logf=$logf.zst
        else
          echo log file $logf not found
          return
        fi
        echo $(realpath $logf)
      }
      function rcmd () { 
        if [[ $1 != *.jobs ]]; then
          local runfile=$1.jobs
        else
          local runfile=$1
        fi
        $w/tools/run_job.sh --lscmd $runfile $2
      }

      function rj {
        if (($#>=2)); then
          _prev_regr=$1;
          _prev_job=$2;
          _rest=${@:3}
          (set -x; ./tools/run_job.sh $1 $2 $_rest)
        elif (($#==1)); then
          _prev_job=$1
          (set -x; ./tools/run_job.sh $_prev_regr $1 $_rest)
        elif (($#==0)); then
          (set -x; ./tools/run_job.sh $_prev_regr $_prev_job $_rest)
        else 
          echo wrong arguments: $*
          exit 2
        fi
      }
      #function rl { eval $(history -p '!rj' | sed "s/^\s*\S*/llogn/"); }
      function rl { llogn $_prev_regr $_prev_job; }
      function rlf { logfn $_prev_regr $_prev_job; }
      function rc { rcmd $_prev_regr $_prev_job; }


      function tllog () { 
        local logf=$(egrep log_is $1 | awk '{print $3}')
        if [[ ! -e $logf ]]; then
          logf=${logf}.gz
          if [[ ! -e $logf ]]; then
            echo log file $logf not found
            return
          fi
        fi
        tmux new-window -c $(realpath $PWD) "vim -X -c 'runtime! macros/less.vim'  -c 'colorscheme kr' $logf"
      }

      function add_path {
        local new=$1
        case ":${PATH:=$new}:" in
          *:"$new":*)  ;;
          *) PATH="$new:$PATH"  ;;
        esac
      }

      function watch_mem {
        if [[ -z "$2" ]]; then sltime=10s; else sltime=$2; fi
        while [[ -d /proc/$1 ]]; do
          sleep $sltime 
          ps -uw -p $1| awk '{print $6}'|grep -v RSS 
        done
      }
      function chpwd () {
        if [[ -z "$FLEXSW_ROOT" ]]; then
          git_root=$(git rev-parse --show-toplevel 2> /dev/null)
          git_root=${git_root/\/afs\/.packetarc.com\/user\/k\/ke\/kenny/$HOME\/afs}
          w=$git_root
        else
          w=$FLEXSW_ROOT
        fi
      }

      # open file with less in a new tmux window
      function tl {
        tmux new-window -c $(realpath $PWD) "vim -X -c 'runtime! macros/less.vim'  -c 'colorscheme kr' $*"
        #tmux new-window -c $(realpath $PWD) "VIMRUNTIME=/h/kenny/share/nvim/runtime /h/kenny/share/bin/nvim -c 'runtime! macros/less.vim'  -c 'colorscheme kr' $*"
      }
      # super simple calculator
      function c() { echo $(($*)); }
      # super simple calculator
      function cx() { printf "0x%x\n" $(($*)); }


      PROMPT_COMMAND=chpwd

      # set variable identifying the chroot you work in (used in the prompt below)
      if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
          debian_chroot=$(cat /etc/debian_chroot)
      fi
      #export PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w [$?] >'

      # set a fancy prompt (non-color, unless we know we "want" color)
      case "$TERM" in
          xterm-color|*-256color) color_prompt=yes;;
      esac

      # uncomment for a colored prompt, if the terminal has the capability; turned
      # off by default to not distract the user: the focus in a terminal window
      # should be on the output of commands, not on the prompt
      #force_color_prompt=yes

      if [ -n "$force_color_prompt" ]; then
          if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
          else
        color_prompt=
          fi
      fi

      if [ "$color_prompt" = yes ]; then
          PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w [$?] \[\033[00m\]>'
      else
          PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w [$?] >'
      fi
unset color_prompt force_color_prompt
      PAC3_REPO=/home/users/kenny/repos/comp
      PAC3_PP=/home/users/kenny/repos/dfgsim/tools/python3/lib/python3.5/site-packages
      function pac3 { withtools pypy3 $w/pac3/pac3.py $* >LOG && egrep Warning LOG ; }
      function pac3n { withtools $w/pac3/pac3.py $* >LOG && egrep Warning LOG ; }

      # run command on server in current directory
      function sd1   { ssh -t sd1   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd2   { ssh -t sd2   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd3   { ssh -t sd3   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd4   { ssh -t sd4   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd5   { ssh -t sd5   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd6   { ssh -t sd6   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd7   { ssh -t sd7   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd8   { ssh -t sd8   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd9   { ssh -t sd9   exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd10  { ssh -t sd10  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd11  { ssh -t sd11  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd12  { ssh -t sd12  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd13  { ssh -t sd13  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd14  { ssh -t sd14  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd15  { ssh -t sd15  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd16  { ssh -t sd16  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd17  { ssh -t sd17  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd18  { ssh -t sd18  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd19  { ssh -t sd19  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd20  { ssh -t sd20  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd21  { ssh -t sd21  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd22  { ssh -t sd22  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd23  { ssh -t sd23  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd24  { ssh -t sd24  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd25  { ssh -t sd25  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd26  { ssh -t sd26  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd27  { ssh -t sd27  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd28  { ssh -t sd28  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd29  { ssh -t sd29  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd30  { ssh -t sd30  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }
      function sd31  { ssh -t sd31  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }

      function sd19x  { ssh -X sd19  exec $SHELL -i -l -c "'cd $PWD; chpwd;  $*'" ; }

      # ssh to server in current directory
      function sd1s   { ssh -t sd1   "cd $PWD; bash -l" ; }
      function sd2s   { ssh -t sd2   "cd $PWD; bash -l" ; }
      function sd3s   { ssh -t sd3   "cd $PWD; bash -l" ; }
      function sd4s   { ssh -t sd4   "cd $PWD; bash -l" ; }
      function sd5s   { ssh -t sd5   "cd $PWD; bash -l" ; }
      function sd6s   { ssh -t sd6   "cd $PWD; bash -l" ; }
      function sd7s   { ssh -t sd7   "cd $PWD; bash -l" ; }
      function sd8s   { ssh -t sd8   "cd $PWD; bash -l" ; }
      function sd9s   { ssh -t sd9   "cd $PWD; bash -l" ; }
      function sd10s  { ssh -t sd10  "cd $PWD; bash -l" ; }
      function sd11s  { ssh -t sd11  "cd $PWD; bash -l" ; }
      function sd12s  { ssh -t sd12  "cd $PWD; bash -l" ; }
      function sd13s  { ssh -t sd13  "cd $PWD; bash -l" ; }
      function sd14s  { ssh -t sd14  "cd $PWD; bash -l" ; }
      function sd15s  { ssh -t sd15  "cd $PWD; bash -l" ; }
      function sd16s  { ssh -t sd16  "cd $PWD; bash -l" ; }
      function sd17s  { ssh -t sd17  "cd $PWD; bash -l" ; }
      function sd18s  { ssh -t sd18  "cd $PWD; bash -l" ; }
      function sd19s  { ssh -t sd19  "cd $PWD; bash -l" ; }
      function sd20s  { ssh -t sd20  "cd $PWD; bash -l" ; }
      function sd21s  { ssh -t sd21  "cd $PWD; bash -l" ; }
      function sd22s  { ssh -t sd22  "cd $PWD; bash -l" ; }
      function sd23s  { ssh -t sd23  "cd $PWD; bash -l" ; }
      function sd24s  { ssh -t sd24  "cd $PWD; bash -l" ; }
      function sd25s  { ssh -t sd25  "cd $PWD; bash -l" ; }
      function sd26s  { ssh -t sd26  "cd $PWD; bash -l" ; }
      function sd27s  { ssh -t sd27  "cd $PWD; bash -l" ; }
      function sd28s  { ssh -t sd28  "cd $PWD; bash -l" ; }
      function sd29s  { ssh -t sd29  "cd $PWD; bash -l" ; }
      function sd30s  { ssh -t sd30  "cd $PWD; bash -l" ; }
      function sd31s  { ssh -t sd31  "cd $PWD; bash -l" ; }

      if [[ $HOSTNAME = "kenny-ThinkPad-X1-Extreme-Gen-5" ]]; then
        function sd28 { ssh -p 27108 packetarc.se ; }
      fi

      function diff_rtl {
        d1=$1
        d2=$2
        for f1 in $d1/*.v; do
          fn=$(basename $f1)
          f2=$d2/$fn
          if [[ ! -e $f2 ]]; then
            echo MISSING $f2
          else
            echo diff $f1 $f2
            ccdiff --no-header -w <(egrep -v '// Date:' $f1) <(egrep -v '// Date:' $f2)
          fi
        done
      }

      export pnightly=/home/files6/regressions/nightly/rundir
      export pweekly=/home/files6/regressions/weekly/rundir
      export prop=/home/files6/regressions/run_on_push/rundir
      export propl=/home/files6/regressions/rop_long/rundir
      export parch=/home/users/archive/deliveries
      export pflex=/home/users/flexcron/flexcron

      function ropsum { (cd $prop; ./tools/list_status.py --summary regression/run_on_push ); }
      function roprunning { (cd $prop; ./tools/list_status.py --running regression/run_on_push); }
      function nitesum { (cd $pnightly; ./tools/list_status.py --summary regression/nightly); }
      function niterunning { (cd $pnightly; ./tools/list_status.py --running regression/nightly); }

      function lropsum { (cd $w; ./tools/list_status.py --summary regression/run_on_push ); }
      function lroprunning { (cd $w; ./tools/list_status.py --running regression/run_on_push); }
      function lnitesum { (cd $w; ./tools/list_status.py --summary regression/nightly); }
      function lniterunning { (cd $w; ./tools/list_status.py --running regression/nightly); }

      function running { (cd $w; ./tools/list_status.py --running $1 ); }
      function summary { (cd $w; ./tools/list_status.py --summary $1 ); }

      function tcgrep {
        if [[ $# = 2 ]]; then
          r=$1
          echo === $r ===
          col1 < ${r%.jobs}.jobs | egrep $2;
        else
          [[ -e regression/run_on_push.jobs ]] && tcgrep regression/run_on_push $1
          [[ -e regression/rop_long.jobs ]] && tcgrep regression/rop_long $1
          [[ -e regression/nightly.jobs ]] && tcgrep regression/nightly $1
        fi
      }

      # blinking bar cursor
      #echo -e -n "\x1b[\x35 q"
      ;;
    *) ;;
esac
function notify { tmux new-window whiptail --msgbox DONE 10 30; }

PATH="/home/users/kenny/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/users/kenny/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/users/kenny/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/users/kenny/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/users/kenny/perl5"; export PERL_MM_OPT;

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:$HOME/.juliaup/bin:*)
        ;;

    *)
        export PATH=$HOME/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

# ------------------------------------------------------
# Manage various dot files in a github repo
# dotfiles status
# dotfiles add .bashrc 
# dotfiles commit -m 'added alias'
# dotfiles push
# 
# To start on a new computer:
# git clone git@github.com:kranerup/dotfiles.git .dotfiles
# dotfiles config --worktree status.showUntrackedFiles no
#
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

#-----------------------------------------------------
export QSYS_ROOTDIR="/opt/quartus/quartus_24.3_pro/qsys/bin"
