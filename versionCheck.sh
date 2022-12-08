#!/bin/zsh
# 1,首先判断changelog版本是否>当前版本,是则继续,否则返回
projectDir="/Users/gikkiares/Desktop/PP_PersonalProject/Mp02_GoalHierachy/Gh01_HadesProject/GhHades01_Sword/05_Make/Sword_Web"
configFilePath="${projectDir}/src/config.js"
changeLogFilePath="${projectDir}/ChangeLog.md"
#提取last version
lastVersion=`awk '/const version/ {print $4}' ${configFilePath}`
lastVersion=${lastVersion/;}
lastVersion=${lastVersion//\"}
echo "last version is: ${lastVersion}"


function updateVersion() {
    currentVersion=$1
    pattern="const version"
    eval "sed -i \"\" 's/${pattern} = \".*\"/${pattern} = \"${currentVersion}\"/' ${configFilePath}"
    [[ $? != 0 ]] && echo "update version failed" && exit
}

# current version
currentVersion=$(awk 'BEGIN {currentTagIndex=0;version=""} {if($1 == "#"){currentTagIndex++; if(currentTagIndex==1){version=""$2;version2=substr(version,2,length(version)-2) ;exit}}} END{print version2}' ${changeLogFilePath})
echo "current version is:${currentVersion}"

if [[ "${currentVersion}" > "${lastVersion}" ]]; then 
    updateVersion ${currentVersion}
    # pwd
    . build/updateBuild.sh
    . build/gitPush.sh
    [[ $? != 0 ]] && echo "git commit failed" && exit
    echo "git commit success"
    exit 0
else
    # 如何返回出错信息?
    echo "current version invalid" >2
    exit -1
fi


