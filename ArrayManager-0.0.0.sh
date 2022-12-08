#!/bin/zsh

# 通过grep判断,1 代表包含 0代表不包含 不支持模式匹配
# echo *.sh,默认输出当前文件夹下的所有sh文件.
# 不太合理.
function isItemInArrayViaGrep {
	itemArray=$2
	item=$1
	cmd="echo ${itemArray[*]} | grep -w ${item}"
	echo "${cmd}"
	eval ${cmd}
	if [[ $? == 0 ]];then
		echo "${item} exclude "
		return 1;
	else
		echo "${item} copy ..."
		return 0;
	fi
	#echo "itemArray is: ${itemArray[@]},item is: ${item}"
}

# $1 字符串
# $2 匹配的模式数组.
# 如果字符串匹配模式数组中任意一个,则返回1
# 都不匹配返回0.
function isItemInArrayViaEnumeration {
	itemArray=$2
	item=$1
	#echo "itemArray is ${itemArray[@]}"
	for excludeItem in ${itemArray[@]}
	do
		#echo "excludeItem is: ${excludeItem},item is: ${item}"
		# item 是原始字符串,excludeItem是匹配模式.
		cmd="echo ${item} | egrep -q ${excludeItem}"
		#echo ${cmd}
		eval ${cmd}
		# grep结果为0表示匹配上.
		if [[ $? == 0 ]]; then
			# 匹配
			# echo "${item} in"
			return 1
		fi
		continue
	done

	# echo "${item} not in"
	return 0;
}

# 使用遍历的方式.
function isItemInArray {
	isItemInArrayViaEnumeration
}

