FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode
ARG NODE_VERSION=20

# Persist bash history
RUN mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory

# Base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    jq \
    make \
    build-essential \
    libssl-dev \
    libffi-dev \
    ca-certificates \
    gnupg \
    lsb-release \
    tree \
    htop \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Node.js (needed for Claude Code extension internals)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- Optional: uncomment for Ruby projects ---
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ruby-full \
#     ruby-dev \
#     && gem install bundler \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# --- Optional: uncomment for Python projects ---
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     python3 \
#     python3-pip \
#     python3-venv \
#     python3-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# Claude Code config dir
RUN mkdir -p /home/$USERNAME/.claude \
    && chown -R $USERNAME /home/$USERNAME/.claude

# Bash history config
RUN echo 'export HISTFILE=/commandhistory/.bash_history' >> /home/$USERNAME/.bashrc \
    && echo 'export HISTSIZE=10000' >> /home/$USERNAME/.bashrc \
    && echo 'export HISTFILESIZE=10000' >> /home/$USERNAME/.bashrc \
    && echo 'shopt -s histappend' >> /home/$USERNAME/.bashrc

USER $USERNAME
WORKDIR /workspace
