export NODE_PATH=/usr/local/lib/node:$PATH
export PATH=/usr/local/share/npm/bin:$PATH

# use zsh
if [ -x `which zsh` ]; then
    exec zsh
fi
