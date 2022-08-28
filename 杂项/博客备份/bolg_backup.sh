#!/bin/bash
#重装系统后注意两处盘符的修改
##exec 1>>G:\MuyanGitBlog\MuyanGit\杂项\博客备份\log.txt 2>&1
##cd G:/MuyanGitBlog/MuyanGit 
NowDateTime=$(date +%Y-%m-%d)
file="log.txt"
filename=${NowDateTime}${file}
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>${filename}: 2>&1
# Everything below will go to the file filename

# 执行的命令主体
echo 开始运行备份命令—————————————— && echo `date`······备份进行中 && hexo clean && hexo g && hexo d && hexo b && echo MuyanGit博客备份 && echo 结束运行备份命令—————————————— && echo `date`······备份结束中