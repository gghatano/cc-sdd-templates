# テンプレート完成チェックリスト

## ディレクトリ構造

- [x] `.claude/skills/technical-advisor/SKILL.md`
- [x] `.claude/skills/project-management/SKILL.md`
- [x] `.claude/skills/architecture-design/SKILL.md`
- [x] `.claude/skills/implementation/SKILL.md`
- [x] `.claude/skills/code-review/SKILL.md`
- [x] `.clinerules`
- [x] `.gitignore`
- [x] `README.md`
- [x] `SETUP.md`
- [x] `doc/仕様書.md`
- [x] `doc/開発方針.md`
- [x] `doc/tasks/README.md`
- [x] `doc/diagrams/README.md`
- [x] `scripts/worktree-manager.sh` (実行権限あり)
- [x] `templates/feature-task.md`
- [x] `templates/bug-report.md`
- [x] `templates/review-checklist.md`

## ファイル確認

### スキルファイル
```bash
ls .claude/skills/*/SKILL.md
```

期待: 5つのSKILL.mdファイルが存在

### スクリプト
```bash
ls -la scripts/
```

期待: worktree-manager.sh が実行権限付きで存在

### ドキュメント
```bash
ls doc/
```

期待: 仕様書.md, 開発方針.md, tasks/, diagrams/ が存在

### テンプレート
```bash
ls templates/
```

期待: 3つの.mdファイルが存在

## 動作確認

### スクリプトのヘルプ表示
```bash
./scripts/worktree-manager.sh help
```

期待: ヘルプメッセージが表示される

### ディレクトリ構造確認
```bash
tree -L 2 .claude/
```

期待: skills/以下に5つのディレクトリが存在

## 完了

すべての項目が完了したら、このテンプレートは使用可能です！

次のステップ:
1. 新しいプロジェクトにコピー
2. SETUP.mdの手順に従ってセットアップ
3. 開発開始
