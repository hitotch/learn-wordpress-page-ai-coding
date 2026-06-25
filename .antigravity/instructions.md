このプロジェクトは GeneratePress + GenerateBlocks（無料版）を使ったWordPress開発環境です。
ページ作成時は以下のルールに従ってください。

## WP-CLIコマンド

Docker環境内のWordPressを操作するには、以下の形式でコマンドを実行してください：

```
docker compose exec wpai-wordpress wp <command> --path=/var/www/html --allow-root
```

## GenerateBlocks ブロックマークアップの必須属性

WP-CLI (`wp post create`) でページを作成する際、GenerateBlocks の各ブロックには以下の属性が **必須** です。
ないと管理画面のビジュアルエディタでバリデーションエラー（「想定されていないか無効なコンテンツが含まれています」）になります。

### uniqueId

各ブロックに `uniqueId`（8桁の一意な16進文字列、例: `a1b2c3d4`）が必要です。ページ内で一意にしてください。

### Container ブロック

```
<!-- wp:generateblocks/container {"uniqueId":"xxxxxxxx","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"..."} -->
（子ブロックをここに配置。<div> タグは含めない — GenerateBlocks が動的に生成する）
<!-- /wp:generateblocks/container -->
```

### Headline ブロック

```
<!-- wp:generateblocks/headline {"uniqueId":"xxxxxxxx","element":"h1","blockVersion":3,"className":"..."} -->
<h1 class="gb-headline gb-headline-{uniqueId} gb-headline-text {className}">テキスト</h1>
<!-- /wp:generateblocks/headline -->
```

`element` は `"h1"` 〜 `"h6"` または `"p"` を指定。

### Text ブロック

```
<!-- wp:generateblocks/text {"uniqueId":"xxxxxxxx","tagName":"p","className":"..."} -->
<p class="gb-text gb-text-{uniqueId} {className}">テキスト</p>
<!-- /wp:generateblocks/text -->
```

## CSS ルール

- 子テーマ（`generatepress-child/`）の `style.css` を直接編集する
- `:root` に定義済みの Design Tokens（CSS変数）を使用する
- CSSクラスのプレフィックス: `wpai-`（BEM記法: `wpai-hero__title`）
- モバイルファースト（`min-width` メディアクエリ）

## 参照ドキュメント

- `docs/ai-workflow-guide.md` — AIを使った開発の全手順（メインガイド）
- `docs/block-markup-reference.md` — ブロックマークアップの書式詳細
- `docs/customizer-guide.md` — カスタマイザー設定
- `docs/production-deploy-guide.md` — 本番適用手順
