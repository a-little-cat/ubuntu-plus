export ZSH=$HOME/.oh-my-zsh
fpath+=$HOME/.oh-my-zsh/themes/pure
autoload -U promptinit; promptinit
prompt pure
plugins=(extract zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh