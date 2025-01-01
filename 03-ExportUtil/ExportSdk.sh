# 将一个项目A导出为A_YYYYMMDD,过滤掉指定的文件夹

# 获取今日日期字符串
dayStr=`date +"%Y-%d-%m"`


# 全局变量
STR_YES="YES"
STR_NO="NO"

COLOR_YELLOW=33
COLOR_WHITE=37


excludeDirNames=(
.hvigor
.idea
.git
oh_modules
build
scripts
99-Raindrop
)
excludeFileName=(

)

declare -A info
info[dir]=0
info[file]=0

echo "excludeDirNames length is: ${#excludeDirNames[@]}"

function logTrace() {
  # adf
  :
}

function copyDirR() {
  local src=$1
  local dst=$2
  local level=$3

  # ls的结果是一个包含空格的长字符串
  result=`ls "$src"`
   # 空文件夹不处理
  [ -z "$result" ] && logTrace "ignore empty dir: $src" && return
  readarray -t items <<< "$result"
  mkdir -p $dst

  for item in "${items[@]}"; do
    local itemPath=$src/$item
    local targetPath=$dst/$item
    ret=$(isItemFile "$itemPath")
    if [ "${ret}" == "${STR_YES}" ]; then
       copyFile "$itemPath" "$targetPath"
       info[file]=$((info[file] + 1))
       log "$level" "${item}"
    else
      ret=$(isItemInArray "$item" excludeDirNames)
      if [ "$ret" == "$STR_YES" ]; then
        logTrace "ignore exclude dir: $item"
      else
        log "$level" "${item}" $COLOR_YELLOW
        copyDirR "$itemPath" "$targetPath" $((level+1))
         info[dir]=$((info[dir] + 1))
      fi
    fi
  done

}

# 拷贝一个文件从a到b
function copyFile() {
  local src=$1
  local dst=$2
  cp $src $dst
}

# 判断项目是否在数组中
# $1 项目名称
# $2 数组
function isItemInArray() {
  item=$1
  declare -n items=$2
  for _item in "${items[@]}"; do
    [ "${item}" == "${_item}" ] && echo "$STR_YES" && return
  done
  echo "$STR_NO"
}

# 判断item是文件夹还是File
function isItemFile() {
  itemPath=$1
  [ -f "$itemPath" ] && echo "$STR_YES" && return
  echo "$STR_NO"
}

# 自定义输出函数
# $1 层级,前面有$1 * 2 个空格.
# $2 要输出的内容
# $3 颜色值
function log() {
  local level=$1
  local content=$2
  local fontColor=$COLOR_WHITE
  [[ -z $3 ]] || fontColor=$3
  for ((i = 0; i < level;i++)); do
    echo -n "  "
  done
  echo -ne "\e[${fontColor}m${content}\e[0m"
  # echo自带一个空行
  echo ""
}

function exportProject() {
  projectPath=$1
  projectName="${projectPath##*/}"
  projectParentDir="${projectPath%/*}"
  exportName=${projectName}_${dayStr}
  exportPath=${projectParentDir}/${exportName}
  echo projectName: $projectName
#  echo $projectParentDir
  echo exportName: $exportName
  echo exportPath: $exportPath

  [ -e $exportPath ] && rm -rf "$exportPath"

  copyDirR "$projectPath" "$exportPath" 0

  echo "done!"
  echo "file:${info[file]},dir:${info[dir]}"
}
