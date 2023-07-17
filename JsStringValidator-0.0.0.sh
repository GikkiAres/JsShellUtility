#判断字符串是否是合法的url.
# return 1 如果合法 0如果不合法.
function isStringValidUrl {
    str=$1
    #去除双引号
    str=`echo $str | sed 's/\"//g'`
    [[ $str == "" ]] && echo "string is empty" && return -1;
    # 验证字符串是否匹配正则.
    # 匹配到返回0 ,没匹配返回1.
    # echo $str | grep "http.*"
    # https://www.test.cn/?lx=1&from=wx#video"
    # echo $str | egrep "^(?:(http|https|ftp):\/\/)?((?:[\w-]+\.)+[a-z0-9]+)((?:\/[^/?#]*)+)?(\?[^#]+)?(#.+)?$/i"
    # 长度大于5.
    echo $str | grep ".\{5,\}"
    [[ $? != 0 ]] && echo "string is not valid url" && return -1;
    # 这里执行完是$? = 1.
    return 0;
}