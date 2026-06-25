# ブロックマークアップ リファレンス

> 📚 **このドキュメントはリファレンスです。**
> 通常の開発では AIがマークアップを自動生成するため、このリファレンスを読む必要はありません。
> AIが生成したマークアップを理解したい場合や、手動で調整したい場合に参照してください。

## ブロックコメント形式

GenerateBlocks のマークアップは **WordPress のブロックコメントで囲む** 必要があります。ブロックコメントがないと WordPress は「クラシック」ブロックとして扱い、ビジュアルエディタでの編集ができなくなります。

### ✅ 正しい形式

```html
<!-- wp:generateblocks/container {"uniqueId":"a1b2c3d4","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-hero"} -->
<!-- wp:generateblocks/headline {"uniqueId":"e5f6a7b8","element":"h1","blockVersion":3,"className":"wpai-hero__title"} -->
<h1 class="gb-headline gb-headline-e5f6a7b8 gb-headline-text wpai-hero__title">見出しテキスト</h1>
<!-- /wp:generateblocks/headline -->
<!-- /wp:generateblocks/container -->
```

### ❌ 間違い（必須属性なし / ブロックコメントなし）

```html
<!-- 必須属性がないとエディタでバリデーションエラーになる -->
<!-- wp:generateblocks/container {"className":"wpai-hero"} -->
<div class="gb-container wpai-hero">...</div>
<!-- /wp:generateblocks/container -->

<!-- ブロックコメント自体がないとクラシックブロック扱いになる -->
<div class="gb-container wpai-hero">
  <h1 class="gb-headline wpai-hero__title">見出しテキスト</h1>
</div>
```

## 必須属性

WP-CLI でページを作成する場合、各ブロックに以下の属性が必要です。これらがないと管理画面のビジュアルエディタでバリデーションエラーが発生します。

> **⚠️ 重要**: フロント画面の表示には影響しませんが、管理画面で「想定されていないか無効なコンテンツが含まれています」というエラーが表示され、ビジュアル編集ができなくなります。

### Container ブロック

```json
{
  "uniqueId": "（8桁の一意な16進数）",
  "isDynamic": true,
  "blockVersion": 4,
  "useInnerContainer": true,
  "className": "（CSSクラス）"
}
```

- `uniqueId`: 8桁の16進文字列（例: `a1b2c3d4`）。ページ内で一意であること
- Container ブロックは **HTML出力（`<div>`）を含めない**。GenerateBlocks が動的に生成する
- 子ブロック（headline, text 等）だけを中に配置する

### Headline ブロック

```json
{
  "uniqueId": "（8桁の一意な16進数）",
  "element": "h1",
  "blockVersion": 3,
  "className": "（CSSクラス）"
}
```

- `element`: 見出しレベル（`"h1"` 〜 `"h6"` または `"p"`）
- HTMLの `class` には `gb-headline gb-headline-{uniqueId} gb-headline-text {className}` を含める

### Text ブロック

```json
{
  "uniqueId": "（8桁の一意な16進数）",
  "tagName": "p",
  "className": "（CSSクラス）"
}
```

- `tagName`: HTMLタグ名（通常は `"p"`）
- HTMLの `class` には `gb-text gb-text-{uniqueId} {className}` を含める

### uniqueId の生成ルール

- **8桁の16進文字列**（例: `a1b2c3d4`, `f0e1d2c3`）
- ページ内の**各ブロックごとに異なる値**を使用すること
- 他のページと重複しても問題ない（ページ内で一意であればOK）

## ブロックタイプ一覧（無料版）

| ブロック | コメントタグ | 用途 |
|---|---|---|
| **Container** | `wp:generateblocks/container` | セクション・レイアウトの囲み |
| **Headline** | `wp:generateblocks/headline` | 見出し（h1〜h6、p） |
| **Text** | `wp:generateblocks/text` | 段落テキスト |
| **Button** | `wp:generateblocks/button` | ボタン（aタグ） |
| **Button Container** | `wp:generateblocks/button-container` | ボタンのラッパー |
| **Grid** | `wp:generateblocks/grid` | グリッドレイアウト |
| **Image** | `wp:image` | 画像（WordPress標準） |

> GenerateBlocks Pro の追加ブロック（Effects, Advanced Backgrounds, Looper 等）は使用しません。

### マークアップのポイント

1. **開始コメントと終了コメント** は必ずペアにする
2. **uniqueId** はブロックごとに一意な8桁の16進文字列
3. **className** でCSSクラスを指定（ブロック設定パネルの「追加CSSクラス」に相当）
4. **gb-headline-{uniqueId}** 等のIDベースクラスを HTML の class 属性に含める
5. 自分のCSSクラス（`wpai-*`）はその後ろに追加する

## マークアップ例

### ヒーローセクション（ヘッドライン + テキスト）

```html
<!-- wp:generateblocks/container {"uniqueId":"aa001122","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-hero"} -->
<!-- wp:generateblocks/headline {"uniqueId":"bb334455","element":"h1","blockVersion":3,"className":"wpai-hero__title"} -->
<h1 class="gb-headline gb-headline-bb334455 gb-headline-text wpai-hero__title">キャッチコピー</h1>
<!-- /wp:generateblocks/headline -->

<!-- wp:generateblocks/text {"uniqueId":"cc667788","tagName":"p","className":"wpai-hero__description"} -->
<p class="gb-text gb-text-cc667788 wpai-hero__description">サブテキスト</p>
<!-- /wp:generateblocks/text -->
<!-- /wp:generateblocks/container -->
```

### セクション（タイトル + 3カラムカード）

```html
<!-- wp:generateblocks/container {"uniqueId":"dd001122","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-services"} -->
<!-- wp:generateblocks/headline {"uniqueId":"ee334455","element":"h2","blockVersion":3,"className":"wpai-services__title"} -->
<h2 class="gb-headline gb-headline-ee334455 gb-headline-text wpai-services__title">サービス紹介</h2>
<!-- /wp:generateblocks/headline -->

<!-- wp:generateblocks/container {"uniqueId":"ff667788","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-card"} -->
<!-- wp:generateblocks/headline {"uniqueId":"aa112233","element":"h3","blockVersion":3,"className":"wpai-card__title"} -->
<h3 class="gb-headline gb-headline-aa112233 gb-headline-text wpai-card__title">サービス1</h3>
<!-- /wp:generateblocks/headline -->
<!-- wp:generateblocks/text {"uniqueId":"bb445566","tagName":"p","className":"wpai-card__text"} -->
<p class="gb-text gb-text-bb445566 wpai-card__text">サービスの説明文</p>
<!-- /wp:generateblocks/text -->
<!-- /wp:generateblocks/container -->

<!-- wp:generateblocks/container {"uniqueId":"cc778899","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-card"} -->
<!-- wp:generateblocks/headline {"uniqueId":"dd001133","element":"h3","blockVersion":3,"className":"wpai-card__title"} -->
<h3 class="gb-headline gb-headline-dd001133 gb-headline-text wpai-card__title">サービス2</h3>
<!-- /wp:generateblocks/headline -->
<!-- wp:generateblocks/text {"uniqueId":"ee224466","tagName":"p","className":"wpai-card__text"} -->
<p class="gb-text gb-text-ee224466 wpai-card__text">サービスの説明文</p>
<!-- /wp:generateblocks/text -->
<!-- /wp:generateblocks/container -->

<!-- wp:generateblocks/container {"uniqueId":"ff335577","isDynamic":true,"blockVersion":4,"useInnerContainer":true,"className":"wpai-card"} -->
<!-- wp:generateblocks/headline {"uniqueId":"aa446688","element":"h3","blockVersion":3,"className":"wpai-card__title"} -->
<h3 class="gb-headline gb-headline-aa446688 gb-headline-text wpai-card__title">サービス3</h3>
<!-- /wp:generateblocks/headline -->
<!-- wp:generateblocks/text {"uniqueId":"bb557799","tagName":"p","className":"wpai-card__text"} -->
<p class="gb-text gb-text-bb557799 wpai-card__text">サービスの説明文</p>
<!-- /wp:generateblocks/text -->
<!-- /wp:generateblocks/container -->
<!-- /wp:generateblocks/container -->
```

---

## 補足: 管理画面での手動投入方法

> この手順は、AIコーディングツールを使わずに手動でページを作成する場合の方法です。
> 通常のワークフローでは不要です。

### 新規ページの場合

1. 管理画面 → 固定ページ → 新規追加
2. 右上の「⋮」（三点メニュー）をクリック
3. 「コードエディター」を選択
4. ブロックマークアップを貼り付け
5. 「ビジュアルエディター」に戻して、正しく表示されることを確認
6. 「公開」ボタンをクリック

### 既存ページの編集

1. 管理画面 → 固定ページ → 編集したいページの「編集」をクリック
2. 同様に「コードエディター」に切り替えてマークアップを編集

> **Tip**: ビジュアルエディターに戻した時に「ブロックのリカバリーを試みる」と表示された場合は、マークアップにエラーがある可能性があります。AIにエラーの修正を依頼してください。

---

## ページのエクスポートとインポート

ローカルで作成したページを本番WordPressに移行する方法です。

### エクスポート手順

1. 管理画面 → ツール → エクスポート
2. 「固定ページ」を選択
3. 「エクスポートファイルをダウンロード」をクリック
4. `.xml` ファイルがダウンロードされる

### インポート手順（本番サーバー）

1. 本番の WordPress 管理画面 → ツール → インポート
2. 「WordPress」の「今すぐインストール」をクリック（初回のみ）
3. 「インポーターの実行」をクリック
4. エクスポートした `.xml` ファイルを選択
5. 「ファイルをアップロードしてインポート」をクリック

### 手動コピーの方法

簡単なページであれば、コードエディターでマークアップをコピー＆ペーストする方が早い場合もあります：

1. ローカルの管理画面でページを開く → コードエディター → マークアップをコピー
2. 本番の管理画面で新規ページを作成 → コードエディター → マークアップを貼り付け

## 注意点

- ブロックマークアップ内の画像URLはローカル環境のURLになっています。本番に移行する際は、画像を本番環境にアップロードしてURLを差し替える必要があります
- GenerateBlocks のバージョンが異なると、マークアップの互換性に問題が出る場合があります。ローカルと本番で同じバージョンを使用することを推奨します
