export LNR_ZSH=$ZSHRC_DIR/zsh/lnr
export OSCAR_VAULT="springernature/oscar"
export REPOS="$HOME/Dev/repos"

#General CLI Shortcuts
function find_in_my_zsh_config(){
  cat $LNR_ZSH | grep $1;
}

alias hg="history | grep"
alias cish='cat $LNR_ZSH'
alias gish='find_in_my_zsh_config'
alias vish='vi $LNR_ZSH'
alias sish="source $LNR_ZSH && echo 'Your zsh is my command'"
alias zsha='echo "$1" >> $LNR_ZSH && source $LNR_ZSH'
alias vsish="vish && sish"

#Git Shortcuts
function ghc(){
 USR=${2:="springernature"}
 if [ "$USR" = "sn" ]; then
  USR="springernature"
 fi

 REPO=$1

 DIR=${3:="$HOME/Dev/repos"}
 if [ "$DIR" = "tools" || "$DIR" = "learning" || "$DIR" = "repos" ]; then 
  DIR="$HOME/Dev/$DIR"
 fi

 echo "cloning $REPO from $USR into $DIR/ using ssh"
 git clone git@github.com:$USR/$REPO.git $DIR/$REPO
}

#Cloudfoundry Shortcuts
alias cft='cf target -s='
alias cfto="cf target -o="

function cf-login-team(){

   CF_CREDS=springernature/$1/cloudfoundry
   API=$(vault read --field=api-$2 $CF_CREDS)
   ORG="content-consumption"

   if [ "$2" = "snpaas" ]; then
     USER=$(vault read --field=username-$2 $CF_CREDS)
     PASS=$(vault read --field=password-$2 $CF_CREDS)
   else
     ORG="$1"
     USER=$(vault read --field=username $CF_CREDS)
     PASS=$(vault read --field=password $CF_CREDS)
   fi

   echo "logging into $2 for team $1"
   cf login -a=$API -u=$USER -p=$PASS

   if [ "$3" != "" ]; then
     cf target -s=$3
   fi
}

function cf-login(){

   API=$(vault read --field=api-$1 $OSCAR_VAULT/cloudfoundry)
   if [ "$1" = "snpaas" ]; then
     USER=$(vault read --field=username-$1 $OSCAR_VAULT/cloudfoundry)
     PASS=$(vault read --field=password-$1 $OSCAR_VAULT/cloudfoundry)
   else
     USER=$(vault read --field=username $OSCAR_VAULT/cloudfoundry)
     PASS=$(vault read --field=password $OSCAR_VAULT/cloudfoundry)
   fi

   echo "logging into $1"
   cf login -a=$API -u=$USER -p=$PASS

   if [ "$2" != "" ]; then
     cf target -s=$2
   fi     

}

