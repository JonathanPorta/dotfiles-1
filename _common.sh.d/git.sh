alias pr='hub pull-request'
alias gup-master='gco master && gup'

# Git related things
# TODO: someday retrain these into git aliases
alias git="hub"
alias gho="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
alias gitpurge="git checkout master && git remote update --prune | git branch -r --merged | grep -v master | sed -e 's/origin\//:/' | xargs git push origin"
alias g='git status -sb'
alias gc="git checkout"
alias gcp="git cherry-pick"
alias gb='git branch'
alias ga='git add'
alias gca='git commit -CHEAD --amend'
alias gd='git diff --color-words'
alias gdc='git diff --cached -w'
alias gdw='git diff --no-ext-diff --word-diff'
alias gdv='git diff'
alias gl='git log --pretty=format:"%Cgreen%h %Creset %s %Cblueby %an (%ar) %G? %Cred %d" --graph'
#alias gl='git log --oneline --decorate'

function clean-remote-branches() {
    git checkout master && git remote update --prune | git branch -r --merged | grep -v master | sed -e 's/origin\//:/'
}
