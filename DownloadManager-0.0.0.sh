# 判断文件夹是否存在且非空
function isDirNotEmpty() {
    dirPath=$1
    if [[ ! -e "${dirPath}" ]]; then
        echo "dir exists"
        return 0;
    fi
    info=`ls ${dirPath}`
    if [[ "${info}" = "" ]]; then
        echo "dir is empty"
        return 0;
    fi
    return 1;
}

function downloadZipIfNeeded() {
    # 压缩包下载地址.
    zipDownloadUrl=$1
    # 文件压缩包名称
    zipPath=$2
    # 解压后的文件夹目录
    dirPath=$3
    dirTopPath=`dirname ${dirPath}`
    
    if [[ ! -e "${dirPath}" ]]; then
        if [[ ! -e "${zipPath}" ]]; then
            curl -o "${zipPath}" "${zipDownloadUrl}"
            [[ $? != 0 ]] && echo "download failed" && exit
        fi
        tar zxvf ${zipPath}  -C "${dirTopPath}"
        [[ $? != 0 ]] && echo "uncompress failed" && exit
    else
        echo "file: ${dirPath} existed."
    fi
}