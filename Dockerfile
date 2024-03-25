# Utiliser une image de base Debian
FROM debian:buster

# Installer les dépendances nécessaires pour pyenv et Python
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    git

# Installer pyenv
RUN curl https://pyenv.run | bash

# Définir les variables d'environnement pour pyenv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Installer Python 3.10.9 avec pyenv et le définir comme version par défaut
RUN pyenv install 3.10.9
RUN pyenv global 3.10.9

# Installer Poetry
RUN curl -sSL https://install.python-poetry.org | python -

#Ajouter le chemin d’installation de poetry à ma variable d’environnement PATH
ENV PATH="/root/.local/bin:${PATH}"

# Configurer Poetry pour ne pas créer d'environnement virtuel
RUN poetry config virtualenvs.create false

# Copier poetry.lock* dans le cas où poetry.lock n'existe pas encore
COPY pyproject.toml poetry.lock* .

# Spécifier le répertoire de travail
WORKDIR /app

# Installer les dépendances
RUN poetry install --no-root


# Copier le reste des fichiers
COPY . /app/

# Exécuter l'application
CMD poetry run streamlit run app.py

