FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode

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
