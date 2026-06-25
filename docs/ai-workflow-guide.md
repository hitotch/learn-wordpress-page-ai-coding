# AIワークフローガイド

> 📖 **このドキュメントはプロジェクトのメインガイドです。** セットアップが完了したら、まずこのガイドを読んでください。

AIコーディングツールを使って、WordPressのページ作成からデザインまで、すべてAIに任せる方法を解説します。

## AIが直接できること

AIコーディングツールは、子テーマのファイル編集に加え、WP-CLI（WordPressのコマンドラインツール）を使ってWordPressを直接操作できます。管理画面を開く必要はありません。

| 操作 | AIがやること | ブラウザ操作 |
|---|---|---|
| ページ作成 | ブロックマークアップ付きでページを作成 | **不要** |
| ページ更新 | 既存ページの内容を書き換え | **不要** |
| CSS追加・編集 | style.css にコンポーネントのCSSを追加 | **不要** |
| PHP追加・編集 | functions.php にフック・機能を追加 | **不要** |
| トップページ設定 | 固定ページをトップページに設定 | **不要** |
| テーマ・プラグイン管理 | インストール・有効化・無効化 | **不要** |
| 結果確認 | ブラウザで表示確認・スクリーンショット | 更新するだけ |

## 実践例: 「Hello AI!」ページを作る

セットアップ完了後、AIに以下のように指示してみましょう。

### Step 1: AIに指示する

```
トップページを作って。「Hello AI!」という大きなヒーローセクションを表示して。
背景はグラデーションで、サブテキストも入れて。
```

### Step 2: AIが自動で実行する

AIは以下をすべて自動で行います（人間の操作は不要です）：

1. GenerateBlocks のブロックマークアップを生成
2. WP-CLI（`wp post create`）でページを作成
3. WP-CLI（`wp option update`）でトップページに設定
4. 子テーマの `style.css` にヒーローセクションのCSSを追加

### Step 3: ブラウザで確認する

`http://localhost` を開く（またはリロードする）だけ。グラデーション背景の「Hello AI!」ヒーローセクションが表示されます。

**ここまでの作業で、管理画面は一度も開いていません。**

### さらに指示を重ねる

```
背景色をもっと暗くして。サブテキストのフォントサイズを大きくして。
```

```
サイドバーを消して全幅にして。
```

```
ヒーローの下に、3カラムのサービス紹介セクションを追加して。
```

AIが `style.css` の修正やWP-CLIでのページ更新を繰り返し、デザインが完成していきます。

---

## ページ作成の仕組み

### WP-CLI とは

WP-CLI は WordPress をコマンドラインから操作するツールです。このプロジェクトの Docker 環境にはあらかじめインストールされています。

AIコーディングツールは `docker compose exec` 経由でこのコマンドを実行し、管理画面を開かずにWordPressを操作します。

### 主なコマンド

| 操作 | コマンド |
|---|---|
| ページ作成 | `docker compose exec wpai-wordpress wp post create --post_type=page --post_title='タイトル' --post_status=publish --post_content='...' --path=/var/www/html --allow-root` |
| ページ更新 | `docker compose exec wpai-wordpress wp post update <ID> --post_content='...' --path=/var/www/html --allow-root` |
| ページ一覧 | `docker compose exec wpai-wordpress wp post list --post_type=page --path=/var/www/html --allow-root` |
| ページ削除 | `docker compose exec wpai-wordpress wp post delete <ID> --force --path=/var/www/html --allow-root` |
| オプション変更 | `docker compose exec wpai-wordpress wp option update <key> <value> --path=/var/www/html --allow-root` |

### ブロックマークアップ

AIがページを作成する際、`--post_content` に GenerateBlocks のブロックマークアップを指定します。

**⚠️ 重要**: GenerateBlocks のブロックには `uniqueId` 等の必須属性があります。これらがないと管理画面のビジュアルエディタでバリデーションエラーが発生します。

| ブロック | 必須属性 |
|---|---|
| **Container** | `uniqueId`, `isDynamic:true`, `blockVersion:4`, `useInnerContainer:true` |
| **Headline** | `uniqueId`, `element`（h1〜h6）, `blockVersion:3` |
| **Text** | `uniqueId`, `tagName:"p"` |

- `uniqueId` は8桁の16進文字列（例: `a1b2c3d4`）。ページ内で一意にすること
- Container ブロックは `<div>` タグを含めない（GenerateBlocks が動的に生成する）

詳しい書式やブロックタイプの一覧については [ブロックマークアップ リファレンス](block-markup-reference.md) を参照してください。

---

## AI用の指示ファイル（自動読み込み）

このリポジトリには、AIコーディングツールが**自動で読み込む指示ファイル**が含まれています。WP-CLIの使い方やGenerateBlocksの正しいマークアップ形式が記載されており、AIは最初から正しいルールを知っている状態で作業を開始します。

| ツール | 自動読み込みファイル |
|---|---|
| Antigravity IDE | `.antigravity/instructions.md` |
| Claude Code | `CLAUDE.md` |

> **これらのファイルは同じ内容です。** 手動で何かを設定する必要はありません。リポジトリをクローンしてAIコーディングツールでプロジェクトを開くだけで、AIが自動でルールを認識します。

---

## CSS 開発

### Design Tokens（CSS変数）

子テーマの `style.css` の `:root` に定義する CSS変数です。色、フォント、スペーシングなどのデザイン値を一元管理します。

```css
:root {
    /* カラー */
    --wpai-primary: #2c3e50;
    --wpai-accent: #3498db;

    /* フォント */
    --wpai-font-primary: 'Noto Sans JP', sans-serif;
    --wpai-font-size-base: 16px;

    /* スペーシング */
    --wpai-space-md: 16px;
    --wpai-space-lg: 32px;
}
```

#### なぜ Design Tokens を使うのか

1. **一箇所変えるだけで全体に反映** — プライマリカラーを変えたい場合、`:root` の値を1箇所変えるだけ
2. **AIが理解しやすい** — 「`--wpai-primary` の色を変えて」と指示できる
3. **一貫性を保てる** — ハードコードされた値がバラバラにならない

#### 命名規則

| カテゴリ | プレフィックス | 例 |
|---|---|---|
| カラー | `--wpai-` | `--wpai-primary`, `--wpai-accent`, `--wpai-text` |
| タイポグラフィ | `--wpai-font-` | `--wpai-font-primary`, `--wpai-font-size-lg` |
| スペーシング | `--wpai-space-` | `--wpai-space-sm`, `--wpai-space-lg` |
| レイアウト | `--wpai-` | `--wpai-container-max`, `--wpai-border-radius` |

### CSS の書き方ルール

1. **モバイルファーストで記述**（`min-width` メディアクエリ）
2. **Design Tokens の変数を使用**（ハードコードした色・サイズは避ける）
3. **コンポーネントごとにセクションコメントで区切る**
4. **BEM記法で命名**（`.wpai-hero__title`, `.wpai-hero__description`）

### CSS プレフィックス

サンプル子テーマでは `wpai-`（WordPress AI の略）をプレフィックスとして使用しています。

```css
/* CSS変数 */
--wpai-primary: #2c3e50;

/* CSSクラス */
.wpai-hero { ... }
.wpai-hero__title { ... }
```

プロジェクトに合わせて自由に変更できます（例: `mysite-`, `corp-`, `pf-` など）。変更する場合は `style.css` 内のCSS変数名とクラス名を一括置換してください。

> **Tip**: AIに「プレフィックスを `mysite-` に変更して」と依頼すると、一括で変換してくれます。

---

## functions.php 開発

### GeneratePress フック

テーマテンプレート外の要素（ヘッダーCTAバー、お知らせバー等）は GeneratePress のフック経由で注入します。

```php
// ヘッダーの前にお知らせバーを追加
add_action('generate_before_header', function () {
    echo '<div class="wpai-announcement-bar">お知らせ内容</div>';
});
```

### 主なフック

| フック名 | 位置 |
|---|---|
| `generate_before_header` | ヘッダーの前 |
| `generate_after_header` | ヘッダーの後 |
| `generate_before_footer` | フッターの前 |
| `generate_before_content` | メインコンテンツの前 |
| `generate_after_content` | メインコンテンツの後 |

> 全フック一覧: [GeneratePress Hooks Reference](https://developer.generatepress.com/hooks/)

---

## AIへの指示のコツ

AIコーディングツールはプロジェクト全体のファイルを自動で読み取ります。Design Tokens やルールを毎回伝える必要はありません。簡潔な指示でOKです。

### 効果的な指示の例

| やりたいこと | 指示例 |
|---|---|
| ページ作成 | 「会社概要ページを作って。代表挨拶と沿革のセクションで」 |
| デザイン変更 | 「ヒーローセクションの背景を暗めに変えて」 |
| レスポンシブ | 「モバイルでカードが縦並びになるようにして」 |
| 機能追加 | 「フッターに著作権表示を追加して」 |
| 複数セクション | 「3カラムのサービス紹介セクションを追加して。アイコン・タイトル・説明で」 |
| トラブル対応 | 「ブラウザで見たらレイアウトが崩れてるので直して」 |

### AIに伝えると精度が上がる情報

- 具体的なデザインイメージ（色、レイアウト、雰囲気）
- 参考サイトのURL
- 対象ページのタイトルやスラッグ

---

## アクセシビリティ要件

AIが生成したコードでも、以下のアクセシビリティ要件を確認してください：

- 適切なセマンティックHTML要素の使用
- カラーコントラスト比の確保（テキスト: 4.5:1以上）
- alt属性の設定（画像）
- GeneratePressのデフォルトのアクセシビリティ機能を上書きしない
