#!/bin/zsh
#	将当前目录下的文件备份一次.
#	排除掉exclude中声明的内容.
#	格式参考.gitignore.

backupDir=../backup


if [[ -e ${backupDir} ]]; then
	rm -rf ${backupDir}
fi

mkdir ${backupDir}
[[ $? != 0 ]] && echo "create backupdir failed" && exit


# 定义exclude数组
exclude[0]="'*.sh'"
exclude[1]=DerivedData
exclude[2]=Pods
exclude[3]=Podfile.lock
exclude[4]=.git
exclude[5]=.gitignore


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





#枚举当前目录的所有文件
function main() {
	# ls忽略了隐藏文件.
	itemArray=`ls`
	for item in ${itemArray}
	do
		#echo "exclude is: ${exclude[*]}"
		#[*]才能传递过去,此时是一个字符串.
		isItemInArrayViaEnumeration "${item}" "${exclude[*]}"
		if [[ $? == 1 ]]; then
			# 排除
			continue
		else
			# copy
			echo "copy ${item} ..."
			cp -rf ${item} ${backupDir}
		fi
	done
}

main
