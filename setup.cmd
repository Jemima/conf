setlocal
set home=%userprofile%\
REM git doesn't like symlinks
mklink /H %home%.gitconfig %~dp0.gitconfig
mklink /H %home%.vimrc %~dp0.vimrc
mklink /H %home%.vsvimrc %~dp0.vsvimrc
