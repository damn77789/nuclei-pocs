#!/bin/bash

# GitHub 仓库配置
REPO_URL="https://github.com/damn77789/nuclei-pocs.git"

# 初始化 git 仓库
echo "初始化 Git 仓库..."
git init

# 添加远程仓库
echo "添加远程仓库..."
git remote add origin "$REPO_URL"

# 添加所有文件
echo "添加所有文件..."
git add .

# 创建提交
echo "创建提交..."
git commit -m "Initial commit: Upload nuclei custom POCs"

# 推送到 GitHub
echo "推送到 GitHub..."
git branch -M main
git push -u origin main --force

echo "上传完成！"
