# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on gnzh which is Based on bira theme

# load some modules
autoload -U zsh/terminfo # Used in the colour alias below
setopt prompt_subst

# make some aliases for the colours: (could use normal escape sequences too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_NO_COLOR➤ $PR_NO_COLOR'
else # root
  eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'
local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'


# add current kubernetes cluster and namespace (if set) to the prompt.
# Prefix with `gke:` if this is a google container engine cluser.
#
#   ‹cluster-01›
#   ‹gke:cluster-01›
#   ‹gke:cluster-01/production›
#
function kube_info() {
  local PREFIX="<"
  local SUFFIX=">"
  local COLOR="%{${FG[140]}%}"
  kubectl="$HOME/google-cloud-sdk/bin/kubectl"

  local cluster=$($kubectl config current-context 2>/dev/null)
  if [[ -z "$cluster" ]]; then
    return
  fi

  local cluster_shortname=$(awk -F_ '{print $NF}' <<< "$cluster")
  namespace=$($kubectl config view -o jsonpath --template "{.contexts[?(@.name==\"$cluster\")].context.namespace}" 2>/dev/null)

  if [[ "$cluster" == gke* ]]; then
    local cluster_shortname="gke:$cluster_shortname"
  fi

  if [[ ! -z "$namespace" ]]; then
    namespace="/$namespace"
  fi
  echo "$COLOR$PREFIX$cluster_shortname$namespace$SUFFIX%{${reset_color}%} "
}

PROMPT="╭─${user_host} $(kube_info) ${git_branch} ${current_dir} 
╰─$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$PR_NO_COLOR%}"
