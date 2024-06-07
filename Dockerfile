# Dockerfileの大元は https://zenn.dev/yamasakit/articles/49abe01fbc00a4 を使用させていただいています
# 言語 バージョンの指定は https://img.atcoder.jp/file/language-update/language-list.html を参照にし、元記事から改変を行っています

# PyPy の公式コンテナを利用する
FROM pypy:3.10-7.3.12-bookworm

# インタラクティブモードにならないようにする
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンを日本に設定
ENV TZ=Asia/Tokyo

# 解凍されたパッケージを設定する時にユーザとの対話をしないようにする
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# インフラを整備
RUN apt-get update \
    && apt-get --no-install-recommends install -y \
    zsh \
    time \
    tzdata \
    tree \
    git \
    curl \
    wget \
    bzip2 \
    gcc \
    g++ \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    pkg-config \
    libgeos-dev \
    nodejs \
    npm \
    clang \
    dirmngr \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    ruby-full \
    build-essential gdb lcov \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libgdbm-compat-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    zlib1g-dev

# root権限でないとnpmのパーミッションが足りないので 先にインストールする
# コンテスト補助アプリケーションをインストール
RUN npm install -g atcoder-cli

# デフォルトシェルを zsh にする
RUN chsh -s /bin/zsh
WORKDIR /tmp

# Install pypy3 and its packages
RUN pypy -m pip install --break-system-packages \
    numpy==1.24.1 \
    scipy==1.10.1 \
    networkx==3.0 \
    sympy==1.11.1 \
    sortedcontainers==2.4.0 \
    more-itertools==9.0.0 \
    shapely==2.0.0 \
    bitarray==2.6.2 \
    PuLP==2.7.0 \
    mpmath==1.2.1 \
    pandas==1.5.2 \
    z3-solver==4.12.1.0 \
    scikit-learn==1.3.0 \
    typing-extensions==4.4.0 \
    cppyy==2.4.1 \
    git+https://github.com/not522/ac-library-python

# rootで作成するとローカルから開けなくなるため 一般ユーザーを作成する
# ローカルのidは1000を想定
RUN groupadd -g 1000 vscode
RUN useradd -m -d /home/vscode -s /bin/bash -u 1000 -g 1000 vscode
ARG USER=vscode
USER ${USER}
ARG HOME=/home/${USER}

# Install pyenv, python3.11 and its packages
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc && \
    . ~/.zshrc \
    && pyenv install 3.11.4 \
    && pyenv global 3.11.4 \
    && pip install --no-cache-dir pip==23.2.1 setuptools==66.0.0 \
    && pip install torch==1.13.1+cpu --index-url https://download.pytorch.org/whl/cpu \
    && pip install --no-cache-dir \
    numpy==1.24.1 \
    scipy==1.10.1 \
    networkx==3.0 \
    sympy==1.11.1 \
    sortedcontainers==2.4.0  \
    more-itertools==9.0.0 \
    shapely==2.0.0 \
    bitarray==2.6.2 \
    PuLP==2.7.0 \
    mpmath==1.2.1 \
    pandas==1.5.2 \
    z3-solver==4.12.1.0 \
    scikit-learn==1.2.0 \
    ortools==9.5.2237 \
    polars==0.15.15 \
    lightgbm==3.3.1 \
    gmpy2==2.1.5 \
    numba==0.57.0 \
    git+https://github.com/not522/ac-library-python

# コンテスト補助アプリケーションをインストール
RUN pip install online-judge-tools 

WORKDIR ${HOME}/workspaces
