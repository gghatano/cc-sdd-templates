#!/bin/bash

# Worktree作成スクリプト

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <feature-name>"
    echo "Example: $0 user-auth"
    exit 1
fi

FEATURE_NAME=$1
BRANCH_NAME="feature/${FEATURE_NAME}"
WORKTREE_PATH="worktrees/${FEATURE_NAME}"

# Worktreeディレクトリが存在しない場合作成
mkdir -p worktrees

# Worktree作成
echo "📁 Creating worktree: ${WORKTREE_PATH}"
echo "🌿 Branch: ${BRANCH_NAME}"

git worktree add "${WORKTREE_PATH}" -b "${BRANCH_NAME}"

echo "✅ Worktree created successfully!"
echo ""
echo "Next steps:"
echo "  cd ${WORKTREE_PATH}"
echo "  # Start development"
