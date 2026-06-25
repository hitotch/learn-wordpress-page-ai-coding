# GeneratePress 子テーマ — サンプル

このフォルダは子テーマのサンプル（テンプレート）です。

## 使い方

ワークスペースルート（`learn-wordpress-page-ai-coding` の親フォルダ）にコピーして使います：

```bash
cp -r learn-wordpress-page-ai-coding/sample-child-theme generatepress-child
```

コピー後、`generatepress-child/style.css` を開いて以下を自分のプロジェクトに合わせて編集してください：

- **Theme Name** — テーマの表示名
- **Description** — テーマの説明
- **Design Tokens** — カラーパレットやフォント設定

## ファイル構成

```
generatepress-child/
├── style.css       ← テーマ情報 + Design Tokens + コンポーネントCSS
├── functions.php   ← 親テーマ読み込み + フックによるカスタマイズ
└── README.md       ← このファイル
```

## 開発ルール

- **親テーマのテンプレートファイルは上書きしない**（ARIA属性・セマンティックHTMLを保持）
- **ブロック設定パネルで色・余白を直接設定しない**（CSSクラスを付与するだけ）
- **CSSクラスはプレフィックスで統一**（デフォルト: `wpai-`、自由に変更可）
- **Design Tokens（CSS変数）で色・サイズを一元管理**

## 参考

- [GeneratePressフック一覧](https://developer.generatepress.com/hooks/)
