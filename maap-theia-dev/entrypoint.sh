#!/bin/bash
#source activate pymaap

source /opt/conda/etc/profile.d/conda.sh
conda activate pymaap
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib


# Ensure $HOME exists when starting
if [ ! -d "${HOME}" ]; then
  mkdir -p "${HOME}"
fi

# Add current (arbitrary) user to /etc/passwd and /etc/group
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi

# check if envvar set if not set it
if [ -z "$CONDA_ENVS_PATH" ]; then
  echo "CONDA_ENVS_PATH not set"
  export CONDA_ENVS_PATH=$PROJECT_SOURCE/envs
  echo "Setting CONDA_ENVS_PATH to $CONDA_ENVS_PATH"
else
  echo "CONDA_ENVS_PATH is set to $CONDA_ENVS_PATH"
fi



#source kubedock_setup
#
## Stow
### Required for https://github.com/eclipse/che/issues/22412
#
## /home/user/ will be mounted to by a PVC if persistUserHome is enabled
#mountpoint -q /home/user/; HOME_USER_MOUNTED=$?
#
## This file will be created after stowing, to guard from executing stow everytime the container is started
#STOW_COMPLETE=/home/user/.stow_completed
#
#if [ $HOME_USER_MOUNTED -eq 0 ] && [ ! -f $STOW_COMPLETE ]; then
#    # Create symbolic links from /home/tooling/ -> /home/user/
#    stow . -t /home/user/ -d /home/tooling/ --no-folding -v 2 > /tmp/stow.log 2>&1
#    # Vim does not permit .viminfo to be a symbolic link for security reasons, so manually copy it
#    cp /home/tooling/.viminfo /home/user/.viminfo
#    # We have to restore bash-related files back onto /home/user/ (since they will have been overwritten by the PVC)
#    # but we don't want them to be symbolic links (so that they persist on the PVC)
#    cp /home/tooling/.bashrc /home/user/.bashrc
#    cp /home/tooling/.bash_profile /home/user/.bash_profile
#    touch $STOW_COMPLETE
#fi

whoami
which python
echo $PATH
echo $@
exec "$@"
