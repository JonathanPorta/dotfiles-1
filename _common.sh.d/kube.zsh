alias kube=kubectl
alias ku='kubectl'
alias kug='kubectl get'
alias kud='kubectl describe'

# cluster swap aliases
alias kube-whereami='kubectl config current-context'
alias dk='kube --namespace development'
alias tk='kube --namespace testing'
alias pk='kube --namespace production'
alias sk='kube --namespace kube-system'
alias tsk='kube --namespace template-sandbox'

alias pgo='cd ~/go/src/github.com/pantheon-systems'

# show all clusters
function list-kube-clusters {
  kubectl config view -o template --template='{{range .users}}{{.name}}{{println " "}}{{end}}'
}

# set default namespace
function kube-default-namespace {
  if [ -z "$1" ] ; then
    echo "provide the namespace name you want to switch to default"
    return
  fi
  set -e
  local CONTEXT=$(kubectl config view | grep current-context | awk '{print $2}')
  kubectl config set-context $CONTEXT --namespace=$1
  kubectl config view | grep namespace:
  set +e
}

# load shell completions
# # using 'antigen bundle kubectl' in top-level .zshrc instead
#if [[ -n "$ZSH_VERSION" ]]; then
#    source <(kubectl completion zsh)
#fi
alias kube-completions='source <(kubectl completion zsh)'

if [[ -n "$BASH_VERSION" ]]; then
    source <(kubectl completion bash)
fi
