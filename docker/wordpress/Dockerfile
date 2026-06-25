FROM wordpress:php8.4-apache

# MySQL接続待機用クライアントとWP-CLI依存パッケージ
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    less \
    && rm -rf /var/lib/apt/lists/*

# WP-CLIインストール
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# セットアップスクリプト
COPY wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

# 権限設定
RUN chown -R www-data:www-data /var/www/html

# 公式entrypointの後にwp-setup.shを実行
ENTRYPOINT ["bash", "-c", "docker-entrypoint.sh apache2-foreground & sleep 5 && /usr/local/bin/wp-setup.sh && wait"]
