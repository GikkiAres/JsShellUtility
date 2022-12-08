#!/bin/zsh
projectDir="/Users/gikkiares/Desktop/PP_PersonalProject/Mp02_GoalHierachy/Gh01_HadesProject/GhHades01_Sword/05_Make/Sword_Web"
filePath="${projectDir}/src/config.js"
pattern="const build"
# sed -i "" 's/String version = ".*"/String version = "abcd"/' 1.java
# awk '/const build/ {print $4}' ${filePath}
#提取build号.
build=`awk '/const build/ {print $4}' ${filePath}`
# 默认$4会当做变量替换掉,配合eval暂时不处理.
# build=eval "awk '/${pattern}/ {print \$4}' ${filePath}"

# 去掉;
build=${build/;}

# 去掉"
build=${build//\"}
# echo "last build is: ${build}"
build=$((++build))
eval "sed -i \"\" 's/${pattern} = \".*\"/${pattern} = \"${build}\"/' ${filePath}"
[[ $? != 0 ]] && echo "update failed" && exit
echo "current build is: ${build}"

