#!/bin/bash
set -e

WP_DIR="/var/www/html"
ENV_FILE="/var/www/.env"
CHILD_THEME_DIR="${WP_DIR}/wp-content/themes/generatepress-child"

# ============================================================
# 1. .env ファイル確認
# ============================================================
if [ ! -f "${ENV_FILE}" ]; then
    echo ""
    echo "============================================================"
    echo "❌ ERROR: .env ファイルが見つかりません。"
    echo "============================================================"
    echo ""
    echo "以下の手順で作成してください："
    echo ""
    echo "  1. プロジェクトフォルダに移動:"
    echo "     cd learn-wordpress-page-ai-coding"
    echo ""
    echo "  2. サンプルをコピー:"
    echo "     cp .env.example .env"
    echo ""
    echo "  3. .env を開いて管理者パスワードとメールアドレスを設定"
    echo ""
    echo "  4. もう一度起動:"
    echo "     docker compose up -d"
    echo ""
    echo "詳細は README.md の「セットアップ手順」を参照してください。"
    echo "============================================================"
    echo ""
    exit 1
fi

# ============================================================
# 2. 子テーマフォルダ確認
# ============================================================
if [ ! -f "${CHILD_THEME_DIR}/style.css" ]; then
    echo ""
    echo "============================================================"
    echo "❌ ERROR: 子テーマフォルダが見つかりません。"
    echo "============================================================"
    echo ""
    echo "以下の手順で子テーマを作成してください："
    echo ""
    echo "  1. ワークスペースルート（learn-wordpress-page-ai-codingの親フォルダ）に移動"
    echo ""
    echo "  2. サンプルをコピー:"
    echo "     cp -r learn-wordpress-page-ai-coding/sample-child-theme generatepress-child"
    echo ""
    echo "  3. generatepress-child/style.css を開いて"
    echo "     Theme Name や Description を自分のプロジェクトに合わせて編集"
    echo ""
    echo "  4. もう一度起動:"
    echo "     cd learn-wordpress-page-ai-coding"
    echo "     docker compose up -d"
    echo ""
    echo "詳細は README.md の「セットアップ手順」を参照してください。"
    echo "============================================================"
    echo ""
    exit 1
fi

# ============================================================
# 3. .env から設定を読み取り
# ============================================================
source <(grep -E '^(WP_ADMIN_USER|WP_ADMIN_PASSWORD|WP_ADMIN_EMAIL|WP_SITE_TITLE|WP_SITE_URL)=' "${ENV_FILE}" 2>/dev/null | sed 's/^/export /')

# パスワード未設定チェック
if [ -z "${WP_ADMIN_PASSWORD}" ] || [ "${WP_ADMIN_PASSWORD}" = "your-password-here" ]; then
    echo ""
    echo "============================================================"
    echo "❌ ERROR: 管理者パスワードが設定されていません。"
    echo "============================================================"
    echo ""
    echo ".env ファイルを開いて WP_ADMIN_PASSWORD を設定してください。"
    echo ""
    echo "  例: WP_ADMIN_PASSWORD=my-secure-password"
    echo ""
    echo "設定後、もう一度起動してください："
    echo "  docker compose up -d"
    echo "============================================================"
    echo ""
    exit 1
fi

if [ -z "${WP_ADMIN_EMAIL}" ] || [ "${WP_ADMIN_EMAIL}" = "your-email@example.com" ]; then
    echo ""
    echo "============================================================"
    echo "❌ ERROR: 管理者メールアドレスが設定されていません。"
    echo "============================================================"
    echo ""
    echo ".env ファイルを開いて WP_ADMIN_EMAIL を設定してください。"
    echo ""
    echo "  例: WP_ADMIN_EMAIL=admin@example.com"
    echo ""
    echo "設定後、もう一度起動してください："
    echo "  docker compose up -d"
    echo "============================================================"
    echo ""
    exit 1
fi

# ============================================================
# 4. MySQL接続待機
# ============================================================
echo "⏳ MySQL接続を待機中..."
for i in $(seq 1 30); do
    if mysqladmin ping -h"wpai-db" -u"wordpress" -p"wordpress" --skip-ssl --silent 2>/dev/null; then
        echo "✅ MySQL接続OK"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ MySQL接続タイムアウト（30回リトライ後）"
        exit 1
    fi
    sleep 2
done

# ============================================================
# 5. WordPress インストール（未インストール時のみ）
# ============================================================
if ! wp core is-installed --path="${WP_DIR}" --allow-root 2>/dev/null; then
    echo "🚀 WordPressをインストール中..."
    wp core install \
        --url="${WP_SITE_URL:-http://localhost}" \
        --title="${WP_SITE_TITLE:-AI Coding Lab}" \
        --admin_user="${WP_ADMIN_USER:-admin}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="${WP_DIR}" --allow-root
    echo "✅ WordPressインストール完了"
else
    echo "✅ WordPressは既にインストール済み"
fi

# ============================================================
# 6. 日本語ロケール設定
# ============================================================
CURRENT_LOCALE=$(wp option get WPLANG --path="${WP_DIR}" --allow-root 2>/dev/null || echo "")
if [ "${CURRENT_LOCALE}" != "ja" ]; then
    echo "🌐 日本語ロケールを設定中..."
    wp language core install ja --path="${WP_DIR}" --allow-root 2>/dev/null || true
    wp site switch-language ja --path="${WP_DIR}" --allow-root 2>/dev/null || true
    echo "✅ 日本語ロケール設定完了"
else
    echo "✅ 日本語ロケールは設定済み"
fi

# ============================================================
# 7. GeneratePressテーマインストール（未インストール時のみ）
# ============================================================
THEME_SLUG="generatepress"
if ! wp theme is-installed "${THEME_SLUG}" --path="${WP_DIR}" --allow-root 2>/dev/null; then
    echo "📦 GeneratePressテーマをインストール中..."
    wp theme install "${THEME_SLUG}" --path="${WP_DIR}" --allow-root
    echo "✅ GeneratePressインストール完了"
else
    echo "✅ GeneratePressは既にインストール済み"
fi

# ============================================================
# 8. GenerateBlocksプラグインインストール＆有効化
# ============================================================
PLUGIN_SLUG="generateblocks"
if ! wp plugin is-installed "${PLUGIN_SLUG}" --path="${WP_DIR}" --allow-root 2>/dev/null; then
    echo "📦 GenerateBlocksプラグインをインストール中..."
    wp plugin install "${PLUGIN_SLUG}" --activate --path="${WP_DIR}" --allow-root
    echo "✅ GenerateBlocksインストール完了"
else
    if ! wp plugin is-active "${PLUGIN_SLUG}" --path="${WP_DIR}" --allow-root 2>/dev/null; then
        wp plugin activate "${PLUGIN_SLUG}" --path="${WP_DIR}" --allow-root
    fi
    echo "✅ GenerateBlocksは既にインストール済み"
fi

# ============================================================
# 9. 子テーマ有効化
# ============================================================
CHILD_THEME="generatepress-child"
if wp theme is-installed "${CHILD_THEME}" --path="${WP_DIR}" --allow-root 2>/dev/null; then
    ACTIVE_THEME=$(wp theme list --status=active --field=name --path="${WP_DIR}" --allow-root 2>/dev/null)
    if [ "${ACTIVE_THEME}" != "${CHILD_THEME}" ]; then
        wp theme activate "${CHILD_THEME}" --path="${WP_DIR}" --allow-root
        echo "✅ 子テーマ ${CHILD_THEME} を有効化"
    else
        echo "✅ 子テーマ ${CHILD_THEME} は既に有効"
    fi
else
    echo "⚠️  子テーマが検出されませんでした。親テーマ GeneratePress を有効化します"
    wp theme activate "${THEME_SLUG}" --path="${WP_DIR}" --allow-root 2>/dev/null || true
fi

# ============================================================
# 10. mu-plugin配置（コアアップデートUI非表示）
# ============================================================
MU_DIR="${WP_DIR}/wp-content/mu-plugins"
mkdir -p "${MU_DIR}"
cat > "${MU_DIR}/disable-core-update-ui.php" << 'EOF'
<?php
// 開発環境用: コアアップデート通知を非表示
add_filter('pre_site_transient_update_core', function() {
    return (object) ['updates' => [], 'version_checked' => get_bloginfo('version')];
});
remove_action('admin_notices', 'update_nag', 3);
EOF
echo "✅ mu-plugin配置完了"

# ============================================================
echo ""
echo "============================================================"
echo "🎉 セットアップ完了！"
echo "============================================================"
echo ""
echo "  フロント画面: ${WP_SITE_URL:-http://localhost}"
echo "  管理画面:     ${WP_SITE_URL:-http://localhost}/wp-admin"
echo "  ユーザー名:   ${WP_ADMIN_USER:-admin}"
echo ""
echo "============================================================"
