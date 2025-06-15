# nvidia公式イメージをベースイメージとして使用
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

# 作業ディレクトリを設定
WORKDIR /app

# 必要なライブラリとツールをインストール
# nvm (Node Version Manager) と最新のLTS版Node.jsをインストール
# claudeユーザーを作成し、sudoグループに追加
RUN apt-get update && apt-get install -y curl python3-pip git sudo && \
    useradd -m -s /bin/bash claude && \
    echo "claude:claude" | chpasswd && \
    adduser claude sudo && \
    # nvmのインストールと設定
    export NVM_DIR="/home/claude/.nvm" && \
    mkdir -p "$NVM_DIR" && \
    chown -R claude:claude "$NVM_DIR" && \
    # claudeユーザーでnvmとclaude-codeをインストール
    runuser -l claude -c ' \
        export NVM_DIR="/home/claude/.nvm" && \
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
        . "$NVM_DIR/nvm.sh" && \
        nvm install --lts && \
        nvm alias default lts/* && \
        export PATH="$NVM_DIR/versions/node/$(nvm current)/bin:$PATH" && \
        npm install -g @anthropic-ai/claude-code \
    ' && \
    # クリーンアップ
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# nvmでインストールしたNode.jsにパスを通し、後続の命令で利用可能にする
ENV NVM_DIR /home/claude/.nvm
ENV PATH $NVM_DIR/versions/node/v[0-9]*.*/bin:$PATH

# requirements.txtをコピー
COPY --chown=claude:claude requirements.txt .

# 必要なPythonライブラリをインストール
# --no-cache-dir オプションでキャッシュを無効化し、イメージサイズを削減
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# 現在のディレクトリのすべてのファイルを作業ディレクトリにコピー
COPY --chown=claude:claude . .

# Gitのグローバル設定
RUN git config --global --add safe.directory /app && \
    git config --global core.filemode false && \
    git config --global core.autocrlf input

# ユーザーをclaudeに切り替え
USER claude