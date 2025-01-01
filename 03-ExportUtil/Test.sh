# 目录是相对于pwd
. ./scripts/ExportSdk.sh


#n=${#excludeDirNames[@]}
#echo $n
#[ $n -eq 7 ] && echo "equal"
#exit


function testLog() {
  log 2 "haha" $COLOR_YELLOW
  log 3 "haha"
}

testLog

#copyDirR "/d/06-company_project/04-chordmail-gap/code/chordmail/common/mail_app/src/main/ets/database/engine_storage/engine_mem_cache" "/d/06-company_project/04-chordmail-gap/code/chordmail/common/mail_app/src/main/ets/database/engine_storage/engine_mem_cache"
