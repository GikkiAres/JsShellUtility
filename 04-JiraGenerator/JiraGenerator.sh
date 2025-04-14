keys=(3221
3215
3120
3138
3016
3219
3253
3161
3245
3247
2881
1603
3177
3070
3072
3073
)

result="project = HMOS AND key in ("
index=0
count=${#keys[@]}
echo "total jira count: $count"
for key in ${keys[@]}; do
  result+=HMOS-$key
  if ((index == count - 1)); then
    result+=")"
  else
    result+=","
  fi
  let index+=1
done
echo $result
