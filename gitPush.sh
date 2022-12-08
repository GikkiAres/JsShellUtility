#!/bin/zsh
projectDir="/Users/gikkiares/Desktop/PP_PersonalProject/Mp02_GoalHierachy/Gh01_HadesProject/GhHades01_Sword/05_Make/Sword_Web"
changeLogFilePath="${projectDir}/ChangeLog.md"

# 版本
version=$(awk 'BEGIN {currentTagIndex=0;version=""} {if($1 == "#"){currentTagIndex++; if(currentTagIndex==1){version=""$2;version2=substr(version,2,length(version)-2) ;exit}}} END{print version2}' ${changeLogFilePath})
echo "\nversion is:\n${version}"

# 改动点
change=$(awk 'BEGIN {currentTagIndex=0;comment="";} {if($1 == "#"){currentTagIndex++;}  else if(currentTagIndex == 1) {comment = (comment""$0"\n")}else if(currentTagIndex>1){exit} } END{print comment}' ${changeLogFilePath})
echo "change is:\n${change}"

# 版本+改动点
comment=$(awk 'BEGIN {currentTagIndex=0;comment="";} {if($1 == "#"){currentTagIndex++;}  if(currentTagIndex == 1) {comment = (comment""$0"\n")}else if(currentTagIndex>1){exit} } END{print comment}' ${changeLogFilePath})
echo "comment is:\n${comment}"

cd ${projectDir}
git add -A
git commit -m "${comment}"
# git push
