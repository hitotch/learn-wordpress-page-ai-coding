<?php
/**
 * GeneratePress 子テーマ — 生成AI活用ページコーディング学習用
 *
 * 開発ワークフロー:
 *   Step 1（グローバル設計）: カスタマイザーでサイト骨格を設定（ヘッダー型、コンテナ幅等）
 *   Step 2（構造化）:         GenerateBlocksでブロック配置 + CSSクラス付与
 *   Step 3（スタイリング）:   この子テーマの style.css でデザインを一括適用
 *   Step 4（動的機能）:       この functions.php でフック経由のPHP処理を追加
 *
 * 子テーマ開発ルール:
 *   - 親テーマのテンプレートファイルは上書きしない（ARIA属性・セマンティックHTMLを保持）
 *   - コンテンツの追加・変更は GeneratePress のフックで行う
 *   - ブロックの設定パネルで色・余白を個別設定しない（CSSクラスを付与するだけ）
 *
 * GeneratePressのフック一覧: https://developer.generatepress.com/hooks/
 */

// --- 親テーマ + 子テーマ スタイルシート読み込み ---
add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style('generatepress-parent', get_template_directory_uri() . '/style.css');
    wp_enqueue_style('gp-child-ai-lab', get_stylesheet_uri(), ['generatepress-parent']);
});

// --- GeneratePressフックの使用例 ---
// ヘッダーの前にお知らせバーを追加する例（コメントを外すと有効になります）
//
// add_action('generate_before_header', function () {
//     echo '<div class="wpai-announcement-bar">お知らせバーの内容</div>';
// });

// 主なフック:
//   generate_before_header  — ヘッダーの前
//   generate_after_header   — ヘッダーの後
//   generate_before_footer  — フッターの前
//   generate_before_content — メインコンテンツの前
