#!/bin/bash

get_accounts_from_system() {
  # 從系統中獲取所有帳號的列表
  local accounts=$(cat /etc/passwd | cut -d ':' -f 1)
  echo $accounts
}

get_password_last_update() {
  # 從 /etc/shadow 中獲取帳號的密碼最後更新時間
  local account=$1
  local date=$(chage -l $account | grep 'Last password change' | cut -d ':' -f 2)
  local date_in_seconds=$(date --date="$date" +%s)
  echo $date_in_seconds
}

three_months=$((3*30*24*60*60))

while true; do
  accounts=$(get_accounts_from_system)

  current_date=$(date +%s)

  for account in $accounts; do
    echo "正在檢查帳號 $account 的密碼最後更新時間..."

    # 獲取帳號的密碼最後更新時間
    last_update=$(get_password_last_update $account)
    last_update_readable=$(date -d @$last_update)
    echo "帳號 $account 的密碼最後更新時間是 $last_update_readable"

    # 如果超過三個月，則發出警告
    if (( (current_date - last_update) > three_months )); then
      echo "警告: 帳號 $account 的密碼已超過三個月未更新"
    fi
  done
  
  sleep 3600
done