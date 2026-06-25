# learn-wordpress-page-ai-coding

AIに指示するだけでWordPressのページが完成する — GeneratePress + GenerateBlocks + AIコーディングツールを使った、新しいWordPressページ開発の学習プロジェクトです。

## このプロジェクトで学べること

AIコーディングツールに話しかけるだけで、WordPressのページが完成します。

1. 「トップページにヒーローセクションを作って」→ AIがページを自動作成＆CSS追加
2. 「背景をグラデーションにして」→ AIがCSSを書き換えて即反映
3. 「ヘッダーにお知らせバーを追加して」→ AIがfunctions.phpを編集
4. 完成したデザインを**どんなWordPressにも適用**できる

### なぜこれが可能なのか

この環境は、AIが直接操作できるように設計されています：

| 仕組み | AIにとっての意味 |
|---|---|
| 子テーマ（CSS/PHP）がテキストファイル | AIが直接読み書きできる |
| WP-CLIが使える | AIがページ作成・設定変更をコマンドで実行できる |
| GenerateBlocksのマークアップが規則的 | AIが正確にブロックを生成できる |
| Design TokensでCSS変数を一元管理 | AIがデザインの全体像を把握できる |

## なぜ GeneratePress なのか？

WordPress のテーマは数多くありますが、AIと一緒にページ開発を行うにはテーマ側の構造が重要です。GeneratePress はAIとの協業に最適な構造を持っています。

| GeneratePressの特徴 | AIとの相性 |
|---|---|
| シンプルで軽量な構造 | 子テーマの CSS + functions.php だけでデザインを完結 → AIが直接ファイルを管理 |
| CSSクラスでスタイリング | ブロック設定パネルではなくCSSクラスでデザインを制御 → コードとして扱える |
| GenerateBlocksとの連携 | ブロックマークアップが規則的 → AIが正確に生成できる |
| WP-CLIとの相性 | テーマ・プラグインの操作がすべてコマンドで可能 → AIが自動実行 |
| カスタマイザーは構造のみ | 設定項目がシンプル → AIにアドバイスを求めやすい |

> **注意**: このプロジェクトでは GeneratePress / GenerateBlocks ともに**無料版**のみを使用します。

## ⚠️ 重要な注意事項

**この環境は開発・学習専用です。本番サーバーでそのまま使用しないでください。**

データベースのパスワードが簡単な文字列に設定されているなど、開発用に特化されています。本番環境では、レンタルサーバーやVPSのWordPressインストール機能を使用してください。

## 必要な環境

### 必須

- **Docker** / **Docker Compose** — ローカル開発環境の構築に使用
- **AIコーディングツール**（以下のいずれか）

| ツール | 形態 | 特徴 |
|---|---|---|
| **[Antigravity IDE](https://antigravity.google/)** | AI統合エディタ | これだけで完結。エディタ内でAIと対話しながら開発 |
| **[VS Code](https://code.visualstudio.com/) + [Claude Code](https://docs.anthropic.com/en/docs/claude-code)** | エディタ + AIターミナル | VS Codeで編集、Claude Codeがファイル操作とコマンド実行 |
| **[VS Code](https://code.visualstudio.com/) + [Antigravity CLI](https://antigravity.google/cli)** | エディタ + AIターミナル | VS Codeで編集、`agy` コマンドでAIと対話 |

> AIコーディングツールがファイルの読み書きとターミナルコマンドの実行を行えることが前提です。

## セットアップ手順

### 1. ワークスペースフォルダを作成

まず、プロジェクト全体を格納するフォルダを作成します。

```bash
mkdir my-wp-project
cd my-wp-project
```

> フォルダ名は自由に変更できます（例: `my-portfolio-site`, `company-website` など）。

### 2. このリポジトリをクローン

```bash
git clone https://github.com/hitotch/learn-wordpress-page-ai-coding.git
```

### 3. 子テーマフォルダを作成

リポジトリ内のサンプルをコピーして、自分の子テーマを作成します。

```bash
cp -r learn-wordpress-page-ai-coding/sample-child-theme generatepress-child
```

コピー後、`generatepress-child/style.css` を開いて、自分のプロジェクトに合わせて編集してください：

```css
/*
 Theme Name:   ここにテーマ名（例: My Portfolio Theme）
 Description:  ここにテーマの説明
 ...
*/
```

> **CSSプレフィックスについて**: サンプルではCSSクラスとCSS変数に `wpai-` プレフィックスを使っています。そのまま使っても、プロジェクトに合わせて変更しても構いません（例: `mysite-`, `corp-` など）。詳しくは [AIワークフローガイド](docs/ai-workflow-guide.md) を参照してください。

### 4. 環境変数を設定

```bash
cd learn-wordpress-page-ai-coding
cp .env.example .env
```

`.env` ファイルを開いて、管理者パスワードとメールアドレスを設定してください：

```env
WP_ADMIN_PASSWORD=my-secure-password
WP_ADMIN_EMAIL=your-email@example.com
```

### 5. ワークスペースファイルを作成（任意・推奨）

Antigravity IDE や VS Code を使う場合、マルチルートワークスペースを設定すると便利です。

ワークスペースルート（`my-wp-project/`）に以下の内容でファイルを作成してください：

**`my-wp-project.code-workspace`**:
```json
{
  "folders": [
    { "path": "learn-wordpress-page-ai-coding" },
    { "path": "generatepress-child" }
  ]
}
```

### 6. Docker環境を起動

```bash
cd learn-wordpress-page-ai-coding
docker compose up -d
```

初回起動時は Docker イメージのビルドに数分かかります。進捗を確認するには：

```bash
docker compose logs -f wpai-wordpress
```

以下のメッセージが表示されたらセットアップ完了です：

```
🎉 セットアップ完了！
```

### 7. 動作確認

- **フロント画面**: [http://localhost](http://localhost)
- **管理画面**: [http://localhost/wp-admin](http://localhost/wp-admin)（確認用）

以下が自動でセットアップされています：

- ✅ 日本語WordPress
- ✅ GeneratePressテーマ（インストール済み）
- ✅ GenerateBlocksプラグイン（有効化済み）
- ✅ 子テーマ（有効化済み）

### 8. AIに話しかけてみよう

セットアップが完了したら、AIコーディングツールに話しかけてみましょう：

```
トップページにヒーローセクションを作って。
「Hello AI!」というタイトルで、背景はグラデーション、サブテキストも入れて。
```

AIがページ作成・CSS追加・トップページ設定まで自動で行います。

> 詳しい使い方は [AIワークフローガイド](docs/ai-workflow-guide.md) を参照してください。

## ディレクトリ構成

```
my-wp-project/                                     ← ワークスペースルート
├── learn-wordpress-page-ai-coding/                 ← メインリポジトリ（このリポジトリ）
│   ├── CLAUDE.md                                   ← AI用指示ファイル（Claude Code）
│   ├── .antigravity/
│   │   └── instructions.md                         ← AI用指示ファイル（Antigravity IDE）
│   ├── docker-compose.yml                          ← Docker環境設定
│   ├── .env.example                                ← 環境変数テンプレート
│   ├── .env                                        ← 環境変数（Git管理外）
│   ├── .gitignore
│   ├── docker/
│   │   ├── wordpress/
│   │   │   ├── Dockerfile                          ← WordPressコンテナ設定
│   │   │   ├── wp-setup.sh                         ← 自動セットアップスクリプト
│   │   │   └── php.ini                             ← PHP設定
│   │   └── db/                                     ← MySQLデータ（Git管理外）
│   ├── wordpress_data/                             ← WordPressファイル（Git管理外）
│   ├── sample-child-theme/                         ← 子テーマのサンプル（コピー元）
│   │   ├── style.css
│   │   ├── functions.php
│   │   └── README.md
│   ├── README.md                                   ← このファイル
│   └── docs/
│       ├── ai-workflow-guide.md                    ← AIワークフローガイド（メイン）
│       ├── customizer-guide.md                     ← カスタマイザー設定ガイド
│       ├── production-deploy-guide.md              ← 本番適用ガイド
│       └── block-markup-reference.md               ← ブロックマークアップリファレンス
├── generatepress-child/                            ← 子テーマ（学習者が作成・編集）
│   ├── style.css                                   ← Design Tokens + コンポーネントCSS
│   ├── functions.php                               ← フック・機能追加
│   └── README.md
└── my-wp-project.code-workspace                    ← エディタ設定（任意）
```

## 開発ワークフロー

AIに自然言語で指示するだけで、すべてが完了します。

| やりたいこと | AIへの指示例 | AIがやること |
|---|---|---|
| ページ作成 | 「トップページにヒーローセクションを作って」 | WP-CLIでページ作成 + CSSを子テーマに追加 |
| デザイン変更 | 「プライマリカラーを緑系に変えて」 | style.css のDesign Tokensを更新 |
| 機能追加 | 「ヘッダーにCTAバーを追加して」 | functions.phpにフックを追加 + CSS追加 |
| 設定変更 | 「サイドバーを消して」 | WP-CLIでレイアウト設定を変更 |
| 確認 | 「ブラウザで見せて」 | ブラウザでスクリーンショットを取得 |

### ガイド

- 📖 [AIワークフローガイド](docs/ai-workflow-guide.md) — AIを使った開発の全手順（**メインガイド**）
- 📖 [カスタマイザー設定ガイド](docs/customizer-guide.md) — サイト構造の設定方法
- 📖 [本番適用ガイド](docs/production-deploy-guide.md) — ローカルから本番への適用手順

### リファレンス

- 📚 [ブロックマークアップ リファレンス](docs/block-markup-reference.md) — AIが生成するブロックの書式詳細（通常は読む必要なし）

## 子テーマ開発のルール

### 絶対に守るルール

1. **親テーマのテンプレートファイルは上書きしない**
   - ARIA属性・セマンティックHTMLは親テーマに任せ、アップデートで自動改善される状態を保つ

2. **ブロック設定パネルで色・余白・フォントを直接設定しない**
   - 代わりに「高度な設定 → 追加CSSクラス」でクラス名を付与する
   - ビジュアルデザインは `style.css` で一元管理する

3. **CSSクラスはプレフィックスで統一**（デフォルト: `wpai-`）
   - 例: `wpai-hero`, `wpai-cta-button`, `wpai-news-section`
   - BEM記法を推奨: `wpai-hero__title`, `wpai-hero__description`

4. **GeneratePress Pro / GenerateBlocks Pro の機能は使わない**
   - このプロジェクトは無料版のみで完結する構成です

5. **カスタマイザーでは構造設定のみ**
   - ヘッダー型、サイドバー有無、コンテナ幅等の構造設定だけ
   - 色・フォント等のビジュアルは `style.css` で管理

## 本番への適用の流れ

ローカルで作成したデザインやページは、以下の手順で本番WordPressに適用できます。

> 本番のWordPressはレンタルサーバーのインストール機能等で構築済みの前提です。

1. **GeneratePress / GenerateBlocks を本番にインストール** — 管理画面から検索してインストール
2. **子テーマを適用** — ZIPファイルにしてアップロード、または FTP でアップロード
3. **カスタマイザー設定を移行** — エクスポート → インポート
4. **ページを移行** — WordPress標準のエクスポート/インポート機能を使用

詳細は [本番適用ガイド](docs/production-deploy-guide.md) を参照してください。

## カスタマイズ

### PHP設定の変更

`docker/wordpress/php.ini` を編集して、以下の設定などをカスタマイズできます：

- `upload_max_filesize`: ファイルアップロード上限
- `memory_limit`: メモリ制限
- `max_execution_time`: 実行時間制限

設定変更後はコンテナを再起動してください：

```bash
docker compose restart wpai-wordpress
```

### 環境のリセット

データベースを含めて最初からやり直したい場合：

```bash
docker compose down
rm -rf wordpress_data docker/db
docker compose up -d
```