# We only want to run gpg-agent on our local workstation. We accomplish that by trying to
# detect if this shell was spawned from ssh or not. If the SSH_CLIENT env var is set, then
# this is probably a remote login and we don't want to run gpg-agent.

if [ ! -n "$SSH_CLIENT" ]; then
  gpgconf --launch gpg-agent
  export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

	GPG_TTY=$(tty)
	export GPG_TTY

    alias restart_gpg_agent="gpgconf --kill gpg-agent; killall -9 gpg-agent ; gpgconf --launch gpg-agent"
fi

if [[ "$OSTYPE" =~ darwin ]] && type gpg2 >/dev/null 2>&1; then
  alias gpg=gpg2
fi
