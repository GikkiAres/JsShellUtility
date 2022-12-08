#!/bin/zsh
projectDir="/Users/gikkiares/Desktop/PP_PersonalProject/Mp02_GoalHierachy/Gh01_HadesProject/GhHades01_Sword/05_Make/Sword_Web"
user="administrator"
server="106.13.237.108"
localDir="${projectDir}/dist"
remoteDir=C:\\02_Software\\10_Tomcat\\02_Install\\webapps\\Sword
#remoteDir2=C:/02_Software/10_Tomcat/02_Install/webapps/AppInfo

# 先删除远程的文件夹
ssh -Tv administrator@106.13.237.108 "rmdir /Q /S ${remoteDir}"
[[ $? != 0 ]] && echo "delete remote file failed" && exit
echo "delete remote file success."
# ssh -Tv administrator@106.13.237.108 "dir ${remoteDir}"

# 将本地的文件夹部署到远程文件夹下面.
scp -r ${localDir} ${user}@${server}:${remoteDir}
[[ $? != 0 ]] && echo "upload project failed" && exit
echo "upload project success."