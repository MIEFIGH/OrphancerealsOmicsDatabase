#!/bin/bash

csv_file="$1"  # 从命令行参数获取CSV文件名

# 检查输入参数是否为空
if [[ -z "$csv_file" ]]; then
    echo "请提供CSV文件名作为参数"
    exit 1
fi

# 提取输入的CSV文件的目录路径
csv_directory=$(dirname "$csv_file")
# 获取csv 第一列的所有编号
column_values=$(awk -F',' 'NR>1 {print $1}' "$csv_file" | sort)
# 获取csv目录下的所有文件的编号
sra_number=$(find "$csv_directory" -exec basename {} \; | awk -F'.' '{print $1}' | sort)
#awk -F',' 'NR>1 {print $1}' "$csv_file" | sort -n > column_values.list
#find "$csv_directory" -exec basename {} \; | awk -F'.' '{print $1}' | sort -n > csv.list

echo 'csv里的未下载的'
comm -23 <(echo "$column_values") <(echo "$sra_number")



echo '目录下多下载的错误的'
comm -13 <(echo "$column_values") <(echo "$sra_number")
