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

# $1 压缩包下载地址
# $2 压缩包存放路径
# $3 解压后的存放路径
#
function downloadZipIfNeeded() {
    # 压缩包下载地址.
    zipDownloadUrl=$1
    # 文件压缩包名称
    zipPath=$2
    # 解压后的文件夹目录
    dstPath=$3
    # dstPath的上层dirPath
    dstDirPath=$(dirname ${dstPath})

    # 判断文件夹是否存在且非空,否则继续.
    isDirNotEmpty ${dstPath}
    [[ $? = 1 ]] && echo "file: ${dstPath} existed." && return 0
    # if [[ ! -e "${dstPath}" ]]; then
    # fi?
    if [[ ! -e "${zipPath}" ]]; then
        curl -o "${zipPath}" "${zipDownloadUrl}"
        [[ $? != 0 ]] && echo "download failed" && exit
    fi
    tar zxvf ${zipPath} -C "${dstDirPath}"
    [[ $? != 0 ]] && echo "uncompress failed" && exit
}
