#!/bin/bash

csv_file="$1"  # 从命令行参数获取CSV文件名

# 检查输入参数是否为空
if [[ -z "$csv_file" ]]; then
    echo "请提供CSV文件名作为参数"
    exit 1
fi

# 提取输入的CSV文件的目录路径
csv_directory=$(dirname "$csv_file")

# 创建输出文件的路径
single_file="$csv_directory/single.list"
paired_file="$csv_directory/paired.list"

# 初始化输出文件，并在第一行写入 "sra_files:"
echo "sra_files:" > "$single_file"
echo "sra_files:" > "$paired_file"

# 读取CSV文件，获取表头
header=$(head -n 1 "$csv_file")

# 查找LibraryLayout所在的列索引
layout_column=$(echo "$header" | awk -F, '{for(i=1;i<=NF;i++) if($i=="LibraryLayout") print i}')

# 如果找到了LibraryLayout列
if [[ -n "$layout_column" ]]; then
    # 遍历CSV文件的每一行
    tail -n +2 "$csv_file" | while IFS=',' read -r line; do
        
        # 获取LibraryLayout列的值
        layout=$(echo "$line" | awk -v col="$layout_column" -F, '{print $col}')
        if [ "$layout" != "SINGLE" ] && [ "$layout" != "PAIRED" ]; then
            echo "有不是single,paired的值被获取，请检查"
            echo "$line" | awk -F, '{print $1}'
        fi

        # 如果LibraryLayout列的值为"SINGLE"
        if [[ "$layout" == "SINGLE" ]]; then
            # 获取该行的第一个字段
            first_field=$(echo "$line" | awk -F, '{print $1}')
            
            # 查找匹配的文件名
            sra_file=$(find "$csv_directory" -name "${first_field}*" -exec basename {} \;)
            
            # 将数据追加到single.list文件中
            echo "    - $sra_file" >> "$single_file"
        
        # 如果LibraryLayout列的值为"PAIRED"
        elif [[ "$layout" == "PAIRED" ]]; then
            # 获取该行的第一个字段
            first_field=$(echo "$line" | awk -F, '{print $1}')
        
            # 查找匹配的文件名
            sra_file=$(find "$csv_directory" -name "${first_field}*" -exec basename {} \;)
            
            # 将数据追加到paired.list文件中
            echo "    - $sra_file" >> "$paired_file"
        fi
    done
fi

echo "单端文件列表已生成：$single_file"
echo "双端文件列表已生成：$paired_file"