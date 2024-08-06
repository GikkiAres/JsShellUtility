#
# 删除匹配的所有远程分支
# 可以把需要保留的分支先重命名到其他模式中.
#
#
#
#

function deleteLocalBranch {
    result=$(git branch --list Gyb/*)
    branches=($result)
    echo branch count: ${#branches[@]}

    #
    # 遍历数组
    for branch in "${branches[@]}"; do
        # echo -e "\r\ndeleting branch is: [$branch]"
        # origin/Gyb/删除空文件夹不需要二次确认2
        # 数组前面多了远程的名称需要去掉
        fixedBranch=${branch#origin/}
        echo -e "\r\ndeleting branch is: [$fixedBranch]"
        # eval "git push origin --delete $fixedBranch"
        git branch -d $fixedBranch
        # 删除没有合并的分支.
        # git branch -D $fixedBranch
        [[ $? != 0 ]] && echo -e "delete branch ${branch} failed\r\n"
    done
}

function deleteRemoteBranch {
    # 这个命令不行,是因为--不识别? 是因为出现了一个不正确的全角-符号?
    # 该命令返回的是一个包含多行的字符串
    result=$(git branch -r --list origin/Gyb/*)
    # 不加双引号,不会显示换行??
    # echo "result is: ${result}"
    # mybranches=`git branch -r -l origin/Gyb*`
    # len=${#result}

    # 将多行的数据通过read命令转化为数组
    # read -ra branches <<< ${result}

    # 数组构造函数,直接能把多行的数据变成数组.
    branches=($result)
    echo banch count: ${#branches[@]}

    #
    # 遍历数组
    for branch in "${branches[@]}"; do
        # echo -e "\r\ndeleting branch is: [$branch]"
        # origin/Gyb/删除空文件夹不需要二次确认2
        # 数组前面多了远程的名称需要去掉
        fixedBranch=${branch#origin/}
        echo -e "\r\ndeleting branch is: [$fixedBranch]"
        eval "git push origin --delete $fixedBranch"
        [[ $? != 0 ]] && echo -e "delete branch ${branch} failed\r\n"
    done
}

function reference() {
    # 列出所有匹配的远程分支
    mybranches=$(eval "git branch -r --list origin/Gyb")
    # 删除远程的分支
    git push origin --delete Gyb/0701_UpdateSdk
    git push origin --delete 0701_UpdateSdk

    # 该命令会列出本地的所有分支，当前分支会在前面加上 * 符号标识。
    git branch --list $pattern

    # 删除本地已经合并到master的分支.
    git branch -d $localBranch

    # 删除本地还没有合并到master的分支,需要强制删除
    git branch -D $localBranch
}

deleteLocalBranch