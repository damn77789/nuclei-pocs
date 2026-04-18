#!/bin/bash

MAX_FILES=999
echo "开始重新组织文件（每个文件夹最多 $MAX_FILES 个文件）..."

# 先移动所有文件到临时目录
echo "收集所有文件..."
mkdir -p temp_all
find . -maxdepth 2 -name "*.yaml" -type f -exec mv {} temp_all/ \; 2>/dev/null

cd temp_all
total_files=$(ls -1 *.yaml 2>/dev/null | wc -l)
echo "总共 $total_files 个文件"

# 计算需要的文件夹数量
folder_count=$(( (total_files + MAX_FILES - 1) / MAX_FILES ))
echo "将创建 $folder_count 个文件夹"

# 创建文件夹并分配文件
counter=0
folder_num=1
mkdir -p "../folder-$folder_num"

echo "开始分配文件..."
for file in *.yaml; do
    if [ -f "$file" ]; then
        mv "$file" "../folder-$folder_num/"
        counter=$((counter + 1))

        if [ $counter -ge $MAX_FILES ]; then
            echo "folder-$folder_num: $counter 个文件"
            counter=0
            folder_num=$((folder_num + 1))
            if [ $folder_num -le $folder_count ]; then
                mkdir -p "../folder-$folder_num"
            fi
        fi
    fi
done

if [ $counter -gt 0 ]; then
    echo "folder-$folder_num: $counter 个文件"
fi

cd ..
rmdir temp_all 2>/dev/null

echo ""
echo "文件重组完成！"

# 重置 git 仓库
echo "重置 Git 仓库..."
rm -rf .git
git init -q
git remote add origin "https://github.com/damn77789/nuclei-pocs.git"

# 配置 git 用户
git config user.email "damn77789@users.noreply.github.com"
git config user.name "damn77789"

# 添加所有文件（使用 -A 更快）
echo "添加文件到 Git..."
git add -A

# 创建提交（禁用 gc 加速）
echo "创建提交..."
git config gc.auto 0
git commit -q -m "Reorganize: Split 9000+ nuclei POCs into folders (max 999 files each)"

# 推送到 GitHub
echo "推送到 GitHub..."
git branch -M main
git push -u origin main --force

echo ""
echo "上传完成！"
