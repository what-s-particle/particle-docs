#!/bin/bash

# 遍历当前目录下的所有子目录
for dir in */; do
  if [[ -d "$dir/.git" ]]; then
    echo "Configuring Git in $dir"
    cd "$dir"
    
    # 在每个Git目录中执行Git配置命令
    git config user.name "Yunlong Wen"
    git config user.email "350394277@qq.com"

    cd ..
    echo "Git configuration completed in $dir"
    echo "----------------------------------"
  fi
done