scriptDirPath=`dirname ${BASH_SOURCE[0]}`


# 如何根据相对路径导入文件.
. $scriptDirPath/JsStringValidator-0.0.0.sh

# 判断文件夹是否存在且非空
function isDirNotEmpty() {
    dstPath=$1
    if [[ ! -e "${dstPath}" ]]; then
        echo "dir not exists"
        return 0
    fi
    info=$(ls ${dstPath})
    if [[ "${info}" = "" ]]; then
        echo "dir is empty"
        return 0
    fi
    return 1
}

# 下载压缩包,并解压重命名为指定path.
# $1 压缩包下载地址
# $2 zipPath,压缩包存放路径
# $3 解压后最终得到的目录
# $4 force,path已经存在,是否删除重新下载.
#
function downloadZipToPath() {
    # 压缩包下载地址.
    zipDownloadUrl=$1
    # 文件压缩包名称
    zipPath=$2
    # 解压后的文件夹目录
    dstPath=$3
    # dstPath的上层dirPath
    containerPath=$(dirname ${dstPath})
    force=$4

    # 验证url的合法性
    isStringValidUrl $zipDownloadUrl

    originTitle=${dstPath##*/}
    name=${zipPath##*/}
    zipExt=`echo $name | grep -oE '(\.[a-zA-Z]+)+$'`
    echo "name: $name,zipExt: $zipExt"
    #使用sed进行动态的替换
    # 首先使用eval进行变量替换,然后执行替换后的脚本就可以了.
    # title=`eval "echo $name | sed 's/$zipExt//g'"`
    # title为最终库文件加压后的文件夹
    eval "title=${name%$zipExt}"
    echo "title: $title"
    
    if [[ -e $dstPath ]]; then 
        if [[ $force == "y" ]]; then
            rm -rf $dstPath
        else
            # 不带返回值0,表示失败了.
            return 0
        fi
    fi
    if [[ ! -e "${zipPath}" ]]; then
        curl -o "${zipPath}" "${zipDownloadUrl}"
        [[ $? != 0 ]] && echo "download failed" && exit
    fi
    tar zxvf ${zipPath} -C "${containerPath}"
    [[ $? != 0 ]] && echo "uncompress failed" && exit
    mv $containerPath/$tilte $containerPath/$originTitle
}


# 1,将项目克隆到指定path
# 2,如果path已经存在在
# $1    url,仓库url
# $2    path,本地path
# $3    force, n,y 如果path已经存在是否重新下载
function cloneProjectToPath() {
    url=$1
    path=$2
    force=$3
    if [[ -e $path ]]; then
        if [[ $force != "y" ]]; then
            return;
        else 
            rm -rf $path
        fi
    fi
    [[ ! -e "$path" ]] && mkdir -p $path
    git clone $url $path
}