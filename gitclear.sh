#!/bin/bash -
#title			:gitclear
#author		 	:Barbaros Yıldırım (barbarosaliyildirim@gmail.com)
#date			:20140902
#version		:0.1.0
#usage			:copy this script into /usr/local/bin folder and
#				 give required rights as executability
#==============================================================================


plc="$1"
act="$2"
#old="$2"
PLACES="-local -remote"
ACTIONS="-D -E"

## Where to delete or keep operation will going on
## has to be decided, by the given params
## first params are controlled for this operation
## '-local' or '-remote' string arrays are possible ones
## other wise error will be shown.
count=0
plc_flag=""
for i in $PLACES; do
    count=$(($count+1))
    if [ $i == $plc ]; then
        if [ $count -eq 1 ]; then
            plc_flag="local"
        elif [ $count -eq 2 ]; then
            plc_flag="remote"
        fi
    fi
done

if [ "$plc_flag" = "" ]; then
    echo "Error occured..
    '-local' for local branches
    '-remote' for remote branches"
    exit
fi

#re='^[0-9]+$'
#if [ "$plc_flag" = "remote" ] && ! [[ $old =~ $re ]]; then
#	echo "Error occured..
#	usage: 'git_clean -local 30 -D blah_branch' "
#	exit
#fi

#if [ "$plc_flag" = "local" ]; then
#	act="$2"
#else
#	act="$3"
#fi

## when the first params are checked
## then the second checking operation moved on as
## up coming params will be kept in any circumstances
## or they are signed as deleted in any case
## decision is one of '-D' or '-E'
## any or none of them seen nothing happened and
## error will shown.
flag=""
count=0
for i in $ACTIONS; do
    count=$(($count+1))
    if [ $i == $act ]; then
        if [ $count -eq 1 ]; then
            flag="direct"
        elif [ $count -eq 2 ]; then
            flag="except"
        fi
    fi
done

if [ "$flag" = "" ]; then
    echo "Error occured..
    '-D' for 'direct'
    '-E' for 'except'"
    exit
fi

## Moved twice, to get famous branch names list
shift && shift
#if [[ $old =~ $re ]] && [ "$plc_flag" = "remote"]; then
#	shift
#fi

## To take all wanted branch list which could be
## wanted ones to delete or to keep
branches=$@
## sys call as git branch will also returned actual files and dictionaries
## to be sure exact branch names, double check has to be performed.
ALL=$(git branch)
LS=$(ls)

## By default master branch taken as movement point
## and also keep in mind not do delete by mistake
git checkout master

for a in $ALL; do
    br_flag=0
    ## As mentioned required filter operation is performing.
    for b in $LS; do
        if [ $a == $b ]; then
            br_flag=1
        fi
    done

    ## When clarity of the poped up name is an actual branch name
    ## Then the second check is as this named branch is
    ## signed for deletion or keeping
    if [ $br_flag -eq 0 ]; then
        de_flag=0
        if [ "$flag" = "direct" ] && [ "$(echo $branches | grep $a)" != "" ]; then
            de_flag=1
        elif [ "$flag" = "except" ] && [ "$(echo $branches | grep $a)" = "" ]; then
            de_flag=1
        fi

        ## if named branch can be deleted then keep it in a list.
        if [ $de_flag -eq 1 ]; then
            BRANCHES="$BRANCHES $a"
        fi
    fi
done

## After all processes is done, collected branches ready to delete.
for b in $BRANCHES; do
    ## For each remote deletion branch list must be reset, not to try,
    ## already removed in last iteration, branch to delete from the repo
    ORIGINAL_BRANCHES=""

    ## For local deletion.
    if [ "$b" != "master" ] && [ "$plc_flag" = "local" ]; then
        git branch -D $b

    ## Or remote delete operation.
    elif [ "$b" != "master" ] && [ "$plc_flag" = "remote" ]; then
        ## find out the possible repos
        ## could be dev origin etc ones.
        ## And delete operation will be
        ## done for each of theö
        REPOS=$(git remote)
        for repo in $REPOS; do
            result=$(git branch -r --list $repo/$b)
            if [ "$result" != "" ]; then
                ORIGINAL_BRANCHES="$ORIGINAL_BRANCHES $repo/$b"
            fi
        done
        ## After finding out the exact branch names
        ## which contains repo and displayed branch names
        ## names are seperated from each other and
        ## git operation will be performed
        for o_branch in $ORIGINAL_BRANCHES; do
            branch_re="${o_branch//// }"
            read -a arr <<<$branch_re
            echo
            echo "$(tput setaf 1)$(tput setab 7) ${arr[1]} $(tput setab 0) branch will be deleted from the $(tput setab 7) ${arr[0]} $(tput setab 0) repo$(tput sgr 0)$(tput bel)"
            read -p "Continue (y/n)? " CONT
            if [ "$CONT" == "y" ]; then
                git push ${arr[0]} :${arr[1]}
            else
                echo "passed"
            fi
        done
    fi
done
