#!/data/data/com.termux/files/usr/bin/bash
# 第七码头没有潮汐 —— 一键入库脚本
# 用法：把本文件和项目文件夹放在一起，在 Termux 或电脑的终端里执行：
#   bash init-git.sh
# 如果之后要推到远程，先改下面 REMOTE 这一行。

set -e

# 远程地址优先取命令行第一个参数，其次取环境变量 PIER7_REMOTE
# 例：bash init-git.sh https://github.com/你的名字/pier7-no-tide.git
REMOTE="${1:-${PIER7_REMOTE:-}}"

cd "$(dirname "$0")"

if [ -d .git ]; then
  echo "[跳过] 已经有 .git 了，直接提交新改动"
else
  git init
  echo "[完成] 仓库初始化"
fi

# /sdcard 是模拟文件系统，设不了权限位，关掉 filemode 免得每次都说改了权限
git config core.filemode false
git config core.quotepath false
git config core.autocrlf false

if [ -z "$(git config user.name || true)" ]; then
  git config user.name "yu"
fi
if [ -z "$(git config user.email || true)" ]; then
  git config user.email "yu@localhost"
fi

git add -A
if git diff --cached --quiet; then
  echo "[跳过] 没有新改动"
else
  git commit -m "第七码头没有潮汐：单文件离线版，占位提示与检索文案脱敏"
  echo "[完成] 已提交"
fi

if [ -n "$REMOTE" ]; then
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$REMOTE"
  else
    git remote add origin "$REMOTE"
  fi
  git branch -M main
  git push -u origin main
  echo "[完成] 已推送到远程"
else
  echo "[提示] 没配远程仓库，只在本机留了提交历史"
fi

echo
echo "----- 当前状态 -----"
git log --oneline -5 || true
git status --short