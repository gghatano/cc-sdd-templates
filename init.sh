#!/bin/bash
#
# init.sh - ccsdd-templates 初期化スクリプト
#
# 使用方法:
#   ./init.sh <repo-name> [target-dir]
#
# 例:
#   ./init.sh my-project           # ~/works/my-project に作成
#   ./init.sh my-project ~/repos   # ~/repos/my-project に作成
#

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 使用方法を表示
usage() {
    echo "使用方法: $0 <repo-name> [target-dir]"
    echo ""
    echo "引数:"
    echo "  repo-name   作成するリポジトリ名（必須）"
    echo "  target-dir  作成先ディレクトリ（デフォルト: ~/works）"
    echo ""
    echo "例:"
    echo "  $0 my-project           # ~/works/my-project に作成"
    echo "  $0 my-project ~/repos   # ~/repos/my-project に作成"
}

# エラーメッセージを表示
error() {
    echo -e "${RED}エラー:${NC} $1" >&2
}

# 成功メッセージを表示
success() {
    echo -e "${GREEN}$1${NC}"
}

# 情報メッセージを表示
info() {
    echo -e "${BLUE}$1${NC}"
}

# 警告メッセージを表示
warn() {
    echo -e "${YELLOW}$1${NC}"
}

# 確認プロンプト
confirm() {
    local message="$1"
    echo -n -e "${YELLOW}$message (y/N): ${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# OS判定してsed -iを実行
sed_inplace() {
    local expression="$1"
    local file="$2"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$expression" "$file"
    else
        sed -i "$expression" "$file"
    fi
}

# メイン処理
main() {
    # 引数チェック
    local REPO_NAME="$1"
    local TARGET_BASE="${2:-$HOME/works}"

    if [[ -z "$REPO_NAME" ]]; then
        error "リポジトリ名が指定されていません"
        echo ""
        usage
        exit 1
    fi

    # リポジトリ名のバリデーション（英数字、ハイフン、アンダースコアのみ）
    if [[ ! "$REPO_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        error "リポジトリ名には英数字、ハイフン、アンダースコアのみ使用できます"
        exit 1
    fi

    local TARGET_DIR="$TARGET_BASE/$REPO_NAME"

    # 作成先ディレクトリの親が存在するか確認
    if [[ ! -d "$TARGET_BASE" ]]; then
        error "作成先ディレクトリが存在しません: $TARGET_BASE"
        exit 1
    fi

    # 既存ディレクトリの確認
    if [[ -d "$TARGET_DIR" ]]; then
        error "ディレクトリが既に存在します: $TARGET_DIR"
        exit 1
    fi

    # 確認プロンプト
    echo ""
    info "=== ccsdd-templates 初期化 ==="
    echo ""
    echo "以下の設定でプロジェクトを作成します:"
    echo "  リポジトリ名: $REPO_NAME"
    echo "  作成先: $TARGET_DIR"
    echo ""

    if ! confirm "続行しますか？"; then
        echo "キャンセルしました"
        exit 0
    fi

    echo ""
    info "プロジェクトを作成中..."

    # rsyncでコピー（除外対象を指定）
    rsync -av \
        --exclude='.git/' \
        --exclude='.DS_Store' \
        --exclude='README.md.backup' \
        --exclude='setup-template.sh' \
        --exclude='CHECKLIST.md' \
        --exclude='init.sh' \
        --exclude='worktrees/' \
        --exclude='.claude/settings.local.json' \
        --exclude='doc/tasks/' \
        "$SCRIPT_DIR/" "$TARGET_DIR/"

    # プレースホルダー置換
    info "プレースホルダーを置換中..."
    sed_inplace "s/{PROJECT_NAME}/$REPO_NAME/g" "$TARGET_DIR/README.md"

    # Git初期化
    info "Gitリポジトリを初期化中..."
    cd "$TARGET_DIR"
    git init
    git add .
    git commit -m "Initial commit from ccsdd-template"

    # 完了メッセージ
    echo ""
    success "✅ プロジェクト作成完了！"
    echo ""
    echo "作成先: $TARGET_DIR"
    echo ""
    info "📋 次のステップ:"
    echo "  1. VSCodeで開く:"
    echo "     code $TARGET_DIR"
    echo ""
    echo "  2. プロジェクト仕様を編集:"
    echo "     - doc/仕様書.md"
    echo "     - doc/開発方針.md"
    echo ""
    echo "  3. 開発を開始:"
    echo "     /pm でタスクを確認"
    echo ""
}

# スクリプト実行
main "$@"
