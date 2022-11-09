#是否是centos
function isCentos() {
    info=$(cat /etc/redhat-release)
    result=$(echo ${info} | grep CentOS)
    if [[ "${result}" != "" ]]; then
        echo "Y"
    else
        echo "N"
    fi
}

# 是否是ubuntu系统
function isUbuntu() {
    result=$(cat /etc/issue | grep Ubuntu)
    if [[ "${result}" != "" ]]; then
        echo "Y"
    else
        echo "N"
    fi
}

# 是否是linux
function isLinux() {
    info=$(uname -a)
    result=$(echo ${info} | grep Linux)
    if [[ "${result}" != "" ]]; then
        echo "Y"
    else
        echo "N"
    fi
}

# 是否是windows
function isWindows() {
    info=$(uname -a)
    result=$(echo ${info} | grep MINGW)
    if [[ "${result}" != "" ]]; then
        echo "Y"
    else
        echo "N"
    fi
}

# 是否是mac
function isMac() {
    info=$(uname -a)
    result=$(echo ${info} | grep Darwin)
    if [[ "${result}" != "" ]]; then
        echo "Y"
    else
        echo "N"
    fi
}
