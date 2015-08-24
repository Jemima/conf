setlocal
set home=%homedrive%%homepath%\
mklink %home%.gitconfig %~dp0.gitconfig
mklink %home%.vimrc %~dp0.vimrc
mklink %home%.vsvimrc %~dp0.vsvimrc
