# git st
git add -A
git commit -m "$(date +%Y-%m-%d\ %H:%M:%S)"
git push
"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:log
read -p "按回车键退出"
# exec /bin/bash
