#!/bin/bash

# 開発ワークフロー支援スクリプト

set -e

echo "🔧 Development Workflow Helper"
echo ""
echo "Select an action:"
echo "  1) List all worktrees"
echo "  2) Create new worktree"
echo "  3) Cleanup worktree"
echo "  4) Show current status"
echo "  5) Exit"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo "📋 Current worktrees:"
        git worktree list
        ;;
    2)
        echo ""
        read -p "Enter feature name: " feature_name
        ./scripts/worktree-setup.sh "$feature_name"
        ;;
    3)
        echo ""
        read -p "Enter feature name to cleanup: " feature_name
        ./scripts/worktree-cleanup.sh "$feature_name"
        ;;
    4)
        echo ""
        echo "📊 Current Status:"
        echo ""
        echo "Current branch:"
        git branch --show-current
        echo ""
        echo "Worktrees:"
        git worktree list
        echo ""
        echo "Recent commits:"
        git log --oneline -5
        ;;
    5)
        echo "👋 Bye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
