#!/bin/zsh

# projectDir="/Users/gikkiares/Desktop/software_project_hierarchy_b/01-stu/01-project_structure/02-node/01-ts/02-server_starter-gap/ga_ts_server_starter_a-p"
# filePath="${projectDir}/src/configs/Config.ts"
# scriptPath是绝对路径时 不需要拼接cwd
# 是相对路径 才需要拼接cwd
# BASH_SOURCE 是命令中使用的脚本的路径,并不是脚本的绝对路径.
cwd=`pwd`
# 转换为linux风格路径,如果是/开头是绝对路径.
scriptPath=`cygpath $BASH_SOURCE`
echo "scriptPath:${scriptPath}"
scriptAbsolutePath=$scriptPath

if [[ $scriptPath != "/"* ]]; then
  echo "not absulote path"
  scriptAbsolutePath=$cwd/$scriptPath
fi

scriptsDir=`dirname $scriptAbsolutePath`
projectDir=`dirname $scriptsDir`
#filePath=package.json
echo "scriptsDir:${scriptsDir}"
echo "projectDir:${projectDir}"

filePath=$projectDir/AppScope/app.json5
echo "filePath:${filePath}"
[[ ! -e $filePath ]] && echo "file not exist" && read && exit

# 切换到项目目录
cd $projectDir

function updateBuildByAwk {
    filePath=$1
    pattern="\"versionCode\":"
    #提取build号.
    build=`awk '/"versionCode":/ {print $2}' $filePath`
    # 默认$4会当做变量替换掉,配合eval暂时不处理.
    # build=eval "awk '/${pattern}/ {print \$4}' $filePath"

    # 去掉;
    build=${build/;/}
    # 去掉"
    build=${build//\"/}
    # 去掉,
    build=${build/,/}
    # echo "last build is: ${build}"
    build=$((++build))
    echo "${build}"
    # mac
    # eval "sed -i \"\" 's/${pattern} .*/${pattern} ${build}/' ${filePath}"
    # windows
    eval "sed -i 's/${pattern} [0-9]*/${pattern} ${build}/' ${filePath}"
    # sed -i "" 's/build:number = .*/build:number = 3/' /Users/gikkiares/Desktop/software_project_hierarchy_b/01-stu/01-project_structure/02-node/01-ts/02-server_starter-gap/ga_ts_server_starter_a-p/src/configs/Config.ts
    [[ $? != 0 ]] && echo "update failed" && exit -1
}

function readBuildByAwk {
    filePath=$1
    pattern="\"versionCode\":"
    #提取build号.
    build=`awk '/"versionCode":/ {print $2}' $filePath`
    # 默认$4会当做变量替换掉,配合eval暂时不处理.
    # build=eval "awk '/${pattern}/ {print \$4}' $filePath"
    # 去掉;
    build=${build/;/}
    # 去掉"
    build=${build//\"/}
    # 去掉,
    build=${build/,/}
    # echo "last build is: ${build}"
    # build=$((++build))
    echo "current build: ${build}"
}

function setBuildBySed {
  # mac
  # eval "sed -i \"\" 's/${pattern} .*/${pattern} ${build}/' ${filePath}"

  # windows
  eval "sed -i 's/${pattern} [0-9]*/${pattern} ${build}/' ${filePath}"
  # sed -i "" 's/build:number = .*/build:number = 3/' /Users/gikkiares/Desktop/software_project_hierarchy_b/01-stu/01-project_structure/02-node/01-ts/02-server_starter-gap/ga_ts_server_starter_a-p/src/configs/Config.ts
  [[ $? != 0 ]] && echo "update failed" && exit -1
}

function main() {
  echo "welcome to use [DailyMergeSystem]"

  # 切换到 master 并检查是新的commitid.
  git checkout master

  currentMasterId=`git log -1 --pretty=format:%h`
  lastMasterId=`cat scripts/master_last_commit_id`

  [[ "${currentMasterId}" == "${lastMasterId}" ]] && echo "current:${currentMasterId},last:${lastMasterId},master is update to date" && read && exit
  echo "current:${currentMasterId},last:${lastMasterId},master has new commit,prepare to merge"

  # 切换到release分支
  git checkout build/release
  [[ $? != 0 ]] && echo "checkout failed"


  # 合并master代码
  git merge master -m "[DailyMergeSystem] [merge master at ${currentMasterId}]"
  [[ $? != 0 ]] && echo "checkout failed"

  currentBuild=`updateBuildByAwk $filePath`

  git add .
  git commit -m "[DailyMergeSystem] [update build ${currentBuild}]"
  git push

  echo ${currentMasterId} >  scripts/master_last_commit_id

  #读取一个字符,让界面停留
  read 
#  > /dev/null
  echo "done."

}

main
