# syntax=docker/dockerfile:1.3-labs

# https://registry.access.redhat.com/ubi8/ubi
FROM --platform=linux/amd64 registry.access.redhat.com/ubi8/ubi:8.9-1107
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="devfile-base-container"
LABEL name="devfile/base-developer-image"
LABEL version="ubi8"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="devfile base developer image"
LABEL description="Image with base developers tools. Languages SDK and runtimes excluded."
LABEL io.k8s.display-name="devfile-developer-base"
LABEL modified.at="IeAT"
LABEL modified.by="Gabriel Iuhasz"
LABEL modified.version="0.0.1"
LABEL modified.for="MAAP"

USER 0

# add env variables
ENV HOME=/home/tooling
ENV BMAP_BACKEND_URL=http://backend-val.biomass-maap.com/bmap-web/

RUN mkdir -p /home/tooling/

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf update -y && \
    dnf install -y bash curl diffutils git git-lfs iproute jq less lsof man nano procps p7zip p7zip-plugins \
                   perl-Digest-SHA net-tools openssh-clients rsync socat sudo time vim wget zip stow && \
                   dnf clean all


## gh-cli
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    GH_VERSION="2.0.0"; \
    GH_ARCH="linux_amd64"; \
    GH_TGZ="gh_${GH_VERSION}_${GH_ARCH}.tar.gz"; \
    GH_TGZ_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/${GH_TGZ}"; \
    GH_CHEKSUMS_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_checksums.txt"; \
    curl -sSLO "${GH_TGZ_URL}"; \
    curl -sSLO "${GH_CHEKSUMS_URL}"; \
    sha256sum --ignore-missing -c "gh_${GH_VERSION}_checksums.txt" 2>&1 | grep OK; \
    tar -zxvf "${GH_TGZ}"; \
    mv "gh_${GH_VERSION}_${GH_ARCH}"/bin/gh /usr/local/bin/; \
    mv "gh_${GH_VERSION}_${GH_ARCH}"/share/man/man1/* /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

## ripgrep
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    RG_VERSION="13.0.0"; \
    RG_ARCH="x86_64-unknown-linux-musl"; \
    RG_TGZ="ripgrep-${RG_VERSION}-${RG_ARCH}.tar.gz"; \
    RG_TGZ_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/${RG_TGZ}"; \
    curl -sSLO "${RG_TGZ_URL}"; \
    tar -zxvf "${RG_TGZ}"; \
    mv "ripgrep-${RG_VERSION}-${RG_ARCH}"/rg /usr/local/bin/; \
    mv "ripgrep-${RG_VERSION}-${RG_ARCH}"/doc/rg.1 /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

## bat
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    BAT_VERSION="0.18.3"; \
    BAT_ARCH="x86_64-unknown-linux-musl"; \
    BAT_TGZ="bat-v${BAT_VERSION}-${BAT_ARCH}.tar.gz"; \
    BAT_TGZ_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_TGZ}"; \
    curl -sSLO "${BAT_TGZ_URL}"; \
    tar -zxvf "${BAT_TGZ}"; \
    mv "bat-v${BAT_VERSION}-${BAT_ARCH}"/bat /usr/local/bin/; \
    mv "bat-v${BAT_VERSION}-${BAT_ARCH}"/bat.1 /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

## fd
RUN \
    TEMP_DIR="$(mktemp -d)" && \
    cd "${TEMP_DIR}" && \
    FD_VERSION="8.7.0" && \
    FD_ARCH="x86_64-unknown-linux-musl" &&\
    FD_TGZ="fd-v${FD_VERSION}-${FD_ARCH}.tar.gz" && \
    FD_TGZ_URL="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/${FD_TGZ}" && \
    curl -sSLO "${FD_TGZ_URL}" && \
    tar -xvf "${FD_TGZ}" && \
    mv "fd-v${FD_VERSION}-${FD_ARCH}"/fd /usr/local/bin && \
    mv "fd-v${FD_VERSION}-${FD_ARCH}"/fd.1 /usr/local/share/man/man1 && \
    cd - && \
    rm -rf "${TEMP_DIR}"

COPY --chown=0:0 entrypoint.sh /
COPY --chown=0:0 .stow-local-ignore /home/tooling/
RUN \
    # add user and configure it
    useradd -u 1234 -G wheel,root -d /home/user --shell /bin/bash -m user && \
    # Setup $PS1 for a consistent and reasonable prompt
    touch /etc/profile.d/udi_prompt.sh && \
    chown 1234 /etc/profile.d/udi_prompt.sh && \
    echo "export PS1='\W \`git branch --show-current 2>/dev/null | sed -r -e \"s@^(.+)@\(\1\) @\"\`$ '" >> /etc/profile.d/udi_prompt.sh && \
    # Copy the global git configuration to user config as global /etc/gitconfig
    # file may be overwritten by a mounted file at runtime
    cp /etc/gitconfig ${HOME}/.gitconfig && \
    chown 1234 ${HOME}/ ${HOME}/.viminfo ${HOME}/.gitconfig ${HOME}/.stow-local-ignore && \
    # Set permissions on /etc/passwd and /home to allow arbitrary users to write
    chgrp -R 0 /home && \
    chmod -R g=u /etc/passwd /etc/group /home && \
    chmod +x /entrypoint.sh && \
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ && \
    # .viminfo cannot be a symbolic link for security reasons, so copy it to /home/user/
    cp /home/tooling/.viminfo /home/user/.viminfo && \
    # Bash-related files are backed up to /home/tooling/ incase they are deleted when persistUserHome is enabled.
    cp /home/user/.bashrc /home/tooling/.bashrc && \
    cp /home/user/.bash_profile /home/tooling/.bash_profile && \
    chown 1234 /home/tooling/.bashrc /home/tooling/.bash_profile

# set user as the owner of /opt
RUN chown -R 1234:0 /opt && \
    chmod -R g=u /opt

# Set CONDA environment variables
ENV CONDA_DIR /opt/conda

# Appending to PATH conda and conda env
ENV PATH "$PATH:$CONDA_DIR/envs/pymaap/bin"
ENV PATH "$PATH:$CONDA_DIR/bin"

# Ajust permissions
#RUN chgrp -Rf root /home/user && chmod -Rf g+w /home/user

USER 1234
ENV HOME=/home/tooling

# Miniconda install
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && rm ~/miniconda.sh

# Create env
COPY environment.yml /tmp
RUN $CONDA_DIR/bin/conda env create -y -f "/tmp/environment.yml" \
    && find $CONDA_DIR/ -follow -type f -name '*.a' -delete \
    && find $CONDA_DIR/ -follow -type f -name '*.js.map' -delete \
    && $CONDA_DIR/bin/conda clean -afy

# Install missing
RUN pip install owslib opencv-python setuptools-scm

# Install maap-py library
RUN mkdir $HOME/maap-py \
    && git clone --single-branch --branch v3.1.4 https://github.com/MAAP-Project/maap-py.git $HOME/maap-py/ \
    && pip install -e $HOME/maap-py/

# use conda env
RUN echo "source activate pymaap" > ~/.bashrc

# Move MAAP stack scpecific scripts to $HOME
COPY RestClient.py $HOME/RestClient.py
COPY quicklook_raster.py $HOME/quicklook_raster.py
COPY ingestData.py $HOME/ingestData.py
COPY ingestData.sh $HOME/ingestData.sh
COPY maap-s3.py $HOME/maap-s3.py
COPY installLib.sh $HOME/installLib.sh

# We add the script folder and the zip file to be able to unzip the structure of the project
COPY initTemplate.sh $HOME/initTemplate.sh
COPY initCredentials.sh $HOME/initCredentials.sh
COPY Project_template.zip $HOME/Project_template.zip
COPY shareAlgorithm.sh $HOME/shareAlgorithm.sh

USER 0
RUN  chmod +x $HOME/initTemplate.sh
RUN  chmod +x $HOME/shareAlgorithm.sh
RUN  chmod +x $HOME/ingestData.sh
RUN  chmod +x $HOME/maap-s3.py
RUN chmod +x $HOME/installLib.sh

#RUN chmod -R g=u /home/user/

USER 1234
# Install adiitional libraries
RUN $HOME/installLib.sh


# Set the working directory
WORKDIR /projects

# Set home dir back to user user
ENV HOME=/home/user
ENV TOOLING_HOME=/home/tooling

# use conda env
RUN echo "source activate pymaap" > ~/.bashrc

ENTRYPOINT ["/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]