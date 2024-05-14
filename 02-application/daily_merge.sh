#!/bin/zsh

# projectDir="/Users/gikkiares/Desktop/software_project_hierarchy_b/01-stu/01-project_structure/02-node/01-ts/02-server_starter-gap/ga_ts_server_starter_a-p"
# filePath="${projectDir}/src/configs/Config.ts"
cwd=`pwd`
scriptPath=$cwd/$BASH_SOURCE
scriptsDir=`dirname scriptPath`
projectDir=`dirname scriptsDir`
#filePath=package.json
echo "scriptPath:${scriptPath}"
filePath=$projectDir/AppScope/app.json5


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
  [[ ! -e $filePath ]] && echo "file not exist"

  # 切换到 master 并检查是新的commitid.
  git checkout master

  currentMasterId=`git log -1 --pretty=format:%h`
  lastMasterId=`cat scripts/master_last_commit_id`

  [[ "${currentMasterId}" == "${lastMasterId}" ]] && echo "current:${currentMasterId},last:${lastMasterId},master is update to date" && exit

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

  echo "done."
}

main
