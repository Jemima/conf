setlocal
set home=%homedrive%%homepath%\
REM git really doesn't like Windows symlinks
mklink /H %home%.gitconfig %~dp0.gitconfig
mklink %home%.vimrc %~dp0.vimrc
mklink %home%.vsvimrc %~dp0.vsvimrc
