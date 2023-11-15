#!/bin/bash

# 從監控系統中獲取所有帳號的列表
accounts=$(get_accounts_from_system)

# 當前日期
current_date=$(date +%s)

# 三個月的秒數
three_months=$((3*30*24*60*60))

for account in $accounts; do
  # 獲取帳號的密碼最後更新時間
  last_update=$(get_password_last_update $account)

  # 如果超過三個月，則發出警告
  if (( (current_date - last_update) > three_months )); then
    echo "警告: 帳號 $account 的密碼已超過三個月未更新"
  fi
done

get_accounts_from_system() {
  # 從系統中獲取所有帳號的列表
  local accounts=$(cat /etc/passwd | cut -d ':' -f 1)
  echo $accounts
}

get_password_last_update() {
  # 從 /etc/shadow 中獲取帳號的密碼最後更新時間
  local account=$1
  local date=$(chage -l $account | grep '最近更改' | cut -d ':' -f 2)
  local date_in_seconds=$(date --date="$date" +%s)
  echo $date_in_seconds
}
```