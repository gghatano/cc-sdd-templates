#!/bin/bash

# Worktree削除スクリプト

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <feature-name>"
    echo "Example: $0 user-auth"
    exit 1
fi

FEATURE_NAME=$1
WORKTREE_PATH="worktrees/${FEATURE_NAME}"
BRANCH_NAME="feature/${FEATURE_NAME}"

# Worktreeが存在するか確認
if [ ! -d "${WORKTREE_PATH}" ]; then
    echo "❌ Worktree not found: ${WORKTREE_PATH}"
    exit 1
fi

# Worktree削除
echo "🗑️  Removing worktree: ${WORKTREE_PATH}"
git worktree remove "${WORKTREE_PATH}"

# ブランチ削除確認
read -p "Delete branch ${BRANCH_NAME}? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -d "${BRANCH_NAME}" 2>/dev/null || git branch -D "${BRANCH_NAME}"
    echo "✅ Branch deleted: ${BRANCH_NAME}"
else
    echo "ℹ️  Branch kept: ${BRANCH_NAME}"
fi

echo "✅ Cleanup completed!"
