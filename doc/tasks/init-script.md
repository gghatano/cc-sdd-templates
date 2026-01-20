# タスク設計書: init.sh - テンプレート初期化スクリプト

## 概要

ccsdd-templatesの内容を新規プロジェクトに展開する初期化スクリプト。
リポジトリ名を入力し、指定ディレクトリに新プロジェクトを作成、
`{PROJECT_NAME}` プレースホルダーを自動置換する。

## 仕様

### 使用方法

```bash
./init.sh <repo-name> [target-dir]

# 例
./init.sh my-project           # ~/works/my-project に作成
./init.sh my-project ~/repos   # ~/repos/my-project に作成
```

### 引数

| 引数 | 必須 | 説明 | デフォルト |
|-----|------|------|-----------|
| repo-name | ✅ | 作成するリポジトリ名 | - |
| target-dir | - | 作成先ディレクトリ | ~/works |

### 除外対象ファイル

以下はコピーされない：

| ファイル/ディレクトリ | 理由 |
|---------------------|------|
| `.git/` | Git履歴は引き継がない |
| `.DS_Store` | macOS固有ファイル |
| `README.md.backup` | バックアップファイル |
| `setup-template.sh` | テンプレート初期構築用 |
| `CHECKLIST.md` | テンプレート完成確認用 |
| `init.sh` | スクリプト自体 |
| `worktrees/` | 並行開発用（空） |
| `.claude/settings.local.json` | ローカル設定 |

### プレースホルダー置換

| プレースホルダー | 置換後 | 対象ファイル |
|----------------|-------|-------------|
| `{PROJECT_NAME}` | 入力したリポジトリ名 | README.md |

## サブタスク分割

| # | サブタスク | 説明 |
|---|-----------|------|
| 1 | 引数・オプション処理 | リポジトリ名、作成先ディレクトリの取得 |
| 2 | バリデーション | 入力値・ディレクトリ存在確認 |
| 3 | ファイルコピー | 除外対象を除いてrsync |
| 4 | プレースホルダー置換 | `{PROJECT_NAME}` を実際の名前に置換 |
| 5 | Git初期化 | git init + 初回コミット |
| 6 | 完了メッセージ | 次のステップを案内 |

## ファイル構成

```
ccsdd-templates/
├── init.sh              # 新規作成: 初期化スクリプト
├── README.md            # 変更: {PROJECT_NAME} プレースホルダー追加
└── (既存ファイル群)
```

## 実装方針

### 技術選定

- **言語**: Bash（追加依存なし）
- **ファイルコピー**: rsync（除外オプションが柔軟）
- **置換**: sed（macOS/Linux両対応）

### 処理フロー

```
1. 引数パース
   ├─ $1: リポジトリ名（必須）
   └─ $2: 作成先ディレクトリ（デフォルト: ~/works）

2. バリデーション
   ├─ リポジトリ名が空でないか
   └─ 作成先に同名ディレクトリが存在しないか

3. 確認プロンプト
   └─ 「~/works/my-project を作成しますか？ (y/N)」

4. rsyncでコピー
   └─ 除外オプション指定

5. プレースホルダー置換
   └─ sed -i で {PROJECT_NAME} を置換

6. Git初期化
   ├─ git init
   ├─ git add .
   └─ git commit -m "Initial commit from ccsdd-template"

7. 完了メッセージ
   └─ 次のステップを表示
```

### OS互換性

macOSとLinuxで `sed -i` の挙動が異なるため、OS判定で分岐：

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/{PROJECT_NAME}/$REPO_NAME/g" "$TARGET_DIR/README.md"
else
  sed -i "s/{PROJECT_NAME}/$REPO_NAME/g" "$TARGET_DIR/README.md"
fi
```

## 実装例（疑似コード）

```bash
#!/bin/bash
set -e

REPO_NAME="$1"
TARGET_BASE="${2:-$HOME/works}"
TARGET_DIR="$TARGET_BASE/$REPO_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# バリデーション
[[ -z "$REPO_NAME" ]] && usage && exit 1
[[ -d "$TARGET_DIR" ]] && error "already exists" && exit 1

# 確認
confirm "Create $TARGET_DIR?"

# コピー
rsync -av --exclude=... "$SCRIPT_DIR/" "$TARGET_DIR/"

# 置換
sed_inplace "s/{PROJECT_NAME}/$REPO_NAME/g" "$TARGET_DIR/README.md"

# Git初期化
cd "$TARGET_DIR" && git init && git add . && git commit -m "Initial commit"

# 完了
echo "✅ Done"
```

## 完了条件

- [ ] `init.sh` がルート直下に作成されている
- [ ] リポジトリ名を引数で受け取れる
- [ ] 作成先ディレクトリを指定できる（デフォルト: ~/works）
- [ ] 除外対象がコピーされない
- [ ] `{PROJECT_NAME}` が置換される
- [ ] Git初期化される
- [ ] 既存ディレクトリがある場合エラーになる
- [ ] README.md の1行目が `# {PROJECT_NAME}` に変更済み

## 注意事項

- macOSとLinuxで `sed -i` の挙動が異なる → OS判定で分岐
- rsyncがない環境は考慮しない（macOS/Linux標準）
- スクリプトはどこからでも実行可能（SCRIPT_DIRで自身の場所を特定）
