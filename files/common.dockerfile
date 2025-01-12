FROM ubuntu:22.04 AS base

# Install basic utilities
RUN echo 'path-include=/usr/share/locale/ja/LC_MESSAGES/*.mo' > /etc/dpkg/dpkg.cfg.d/includes \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    build-essential \
    curl \
    less \
    apt-utils \
    tzdata \
    git \
    tmux \
    bash-completion \
    command-not-found \
    libglib2.0-0 \
    vim \
    emacs \
    ssh \
    rsync \
    python3-pip \
    sed \
    ca-certificates \
    wget \
    lsb-release \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install additional packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    software-properties-common \
    alsa-base \
    alsa-utils \
    apt-transport-https \
    apt-utils \
    build-essential \
    ca-certificates \
    cups-filters \
    cups-common \
    cups-pdf \
    curl \
    file \
    wget \
    bzip2 \
    gzip \
    p7zip-full \
    xz-utils \
    zip \
    unzip \
    zstd \
    gcc \
    git \
    jq \
    make \
    python3 \
    python3-cups \
    python3-numpy \
    nano \
    vim \
    htop \
    fonts-dejavu-core \
    fonts-freefont-ttf \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-noto-color-emoji \
    fonts-noto-hinted \
    fonts-noto-mono \
    fonts-opensymbol \
    fonts-symbola \
    fonts-ubuntu \
    libpulse0 \
    pulseaudio \
    supervisor \
    net-tools \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libglu1 \
    libsm6 \
    vainfo \
    vdpauinfo \
    pkg-config \
    mesa-utils \
    mesa-utils-extra \
    va-driver-all \
    xserver-xorg-input-all \
    xserver-xorg-video-all \
    mesa-vulkan-drivers \
    libvulkan-dev \
    libxau6 \
    libxdmcp6 \
    libxcb1 \
    libxext6 \
    libx11-6 \
    libxv1 \
    libxtst6 \
    xdg-utils \
    dbus-x11 \
    libdbus-c++-1-0v5 \
    xkb-data \
    x11-xkb-utils \
    x11-xserver-utils \
    x11-utils \
    x11-apps \
    xauth \
    xbitmaps \
    xinit \
    xfonts-base \
    libxrandr-dev \
    vulkan-tools \
    && rm -rf /var/lib/apt/lists/*

# Install KDE and other packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    kde-plasma-desktop \
    kwin-addons \
    kwin-x11 \
    kdeadmin \
    akregator \
    ark \
    baloo-kf5 \
    breeze-cursor-theme \
    breeze-icon-theme \
    debconf-kde-helper \
    colord-kde \
    desktop-file-utils \
    filelight \
    gwenview \
    hspell \
    kaddressbook \
    kaffeine \
    kate \
    kcalc \
    kcharselect \
    kdeconnect \
    kde-spectacle \
    kde-config-screenlocker \
    kde-config-updates \
    kdf \
    kget \
    kgpg \
    khelpcenter \
    khotkeys \
    kimageformat-plugins \
    kinfocenter \
    kio-extras \
    kleopatra \
    kmail \
    kmenuedit \
    knotes \
    kontact \
    kopete \
    korganizer \
    krdc \
    ktimer \
    kwalletmanager \
    librsvg2-common \
    okular \
    okular-extra-backends \
    plasma-dataengines-addons \
    plasma-discover \
    plasma-runners-addons \
    plasma-wallpapers-addons \
    plasma-widgets-addons \
    plasma-workspace-wallpapers \
    qtvirtualkeyboard-plugin \
    sonnet-plugins \
    sweeper \
    systemsettings \
    xdg-desktop-portal-kde \
    kubuntu-restricted-extras \
    kubuntu-wallpapers \
    kubuntu-desktop \
    pavucontrol-qt \
    transmission-qt \
    libreoffice \
    libreoffice-style-breeze \
    && rm -rf /var/lib/apt/lists/*

# Install additional utilities
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xrdp \
    supervisor \
    htop \
    ubuntu-wallpapers \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV XDG_CURRENT_DESKTOP KDE
ENV KWIN_COMPOSE N
ENV SUDO_EDITOR kate
ENV ROS_DISTRO=humble
ENV GUROBI_HOME=/opt/gurobi/linux
ENV PATH=$GUROBI_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$GUROBI_HOME/lib:$LD_LIBRARY_PATH
ENV GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic
ENV CMAKE_PREFIX_PATH=$GUROBI_HOME

# Add Mozilla PPA and install Firefox
RUN add-apt-repository ppa:mozillateam/ppa \
    && { \
    echo 'Package: firefox*'; \
    echo 'Pin: release o=LP-PPA-mozillateam'; \
    echo 'Pin-Priority: 1001'; \
    echo ' '; \
    echo 'Package: firefox*'; \
    echo 'Pin: release o=Ubuntu*'; \
    echo 'Pin-Priority: -1'; \
    } > /etc/apt/preferences.d/99mozilla-firefox \
    && apt-get update \
    && apt-get install -y firefox

# Install ROS2 Humble
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop-full \
    ros-dev-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install colcon and rosdep
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions \
    python3-rosdep \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install clinfo
RUN apt-get update && apt-get install -y --no-install-recommends \
    clinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set XDG_RUNTIME_DIR
RUN echo 'export XDG_RUNTIME_DIR=/tmp/runtime-$(id -un)' >> /etc/profile

# Install Pulseaudio
RUN apt-get update && apt-get install -y libtool libpulse-dev git autoconf pkg-config libssl-dev libpam0g-dev libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex bison libxml2-dev dpkg-dev libcap-dev meson ninja-build libsndfile1-dev libtdb-dev check doxygen libxml-parser-perl libxtst-dev gettext \
    && git clone --recursive https://github.com/pulseaudio/pulseaudio.git \
    && cd pulseaudio && git checkout tags/v16.1 -b v16.1 && meson build && ninja -C build \
    && cd ../ && git clone --recursive https://github.com/neutrinolabs/pulseaudio-module-xrdp.git \
    && cd pulseaudio-module-xrdp/ && ./bootstrap && ./configure PULSE_DIR=$(pwd)/../pulseaudio && make && make install

# Initialize rosdep
RUN rosdep init

# Expose RDP port
EXPOSE 3389

# Set up KDE session
RUN echo "startplasma-x11" > /etc/skel/.xsession \
    && install -o root -g xrdp -m 2775 -d /var/run/xrdp \
    && install -o root -g xrdp -m 3777 -d /var/run/xrdp/sockdir \
    && install -o root -g root -m 0755 -d /var/run/dbus

# Clean up apt cache
RUN { \
    echo '#DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };'; \
    echo '#APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };'; \
    echo '#Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";'; \
    } > /etc/apt/apt.conf.d/docker-clean

# Añade una línea para imprimir el valor de TARGETPLATFORM
RUN echo "TARGETPLATFORM is $TARGETPLATFORM"

# Añade una línea para imprimir el valor de TARGETARCH
RUN echo "TARGETARCH is $TARGETARCH"
RUN uname -m

# Condicional para escribir en /platform.txt según la arquitectura
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] || [ "$(uname -m)" = "aarch64" ]; then \
          echo "armlinux64" > /platform.txt; \
      elif [ "$TARGETARCH" = "arm64" ]; then \
          echo "armlinux64" > /platform.txt; \
      else \
          echo "linux64" > /platform.txt; \
      fi

RUN cat /platform.txt

# Install Gurobi
ARG GRB_VERSION=11.0.2
ARG GRB_SHORT_VERSION=11.0
ARG TARGETPLATFORM
ARG TARGETARCH

WORKDIR /opt

RUN export GRB_PLATFORM=$(cat /platform.txt) && echo $GRB_PLATFORM \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
       ca-certificates  \
       wget \
    && update-ca-certificates \
    && wget -v https://packages.gurobi.com/${GRB_SHORT_VERSION}/gurobi${GRB_VERSION}_$GRB_PLATFORM.tar.gz \
    && tar -xvf gurobi${GRB_VERSION}_$GRB_PLATFORM.tar.gz  \
    && rm -f gurobi${GRB_VERSION}_$GRB_PLATFORM.tar.gz \
    && mv -f gurobi* gurobi \
    && rm -rf gurobi/$GRB_PLATFORM/docs \
    && mv -f gurobi/$GRB_PLATFORM*  gurobi/linux

WORKDIR /opt/gurobi

ENV GUROBI_HOME /opt/gurobi/linux
ENV PATH $PATH:$GUROBI_HOME/bin
ENV LD_LIBRARY_PATH $GUROBI_HOME/lib

COPY gurobi.lic /opt/gurobi/

# ROS fundamentals
RUN apt-get update && apt-get install -y \
        build-essential \
        python3-colcon-common-extensions \
        python3-pip \
        python3-pybind11 \
        python3-pytest-cov \
        python3-rosdep \
        python3-rosinstall-generator \
        python3-vcstool \
        wget \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Install libraries via pip
RUN pip install digi-xbee

# Use Cyclone DDS as middleware
RUN apt-get update && apt-get install -y --no-install-recommends \
 ros-${ROS_DISTRO}-rmw-cyclonedds-cpp
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Install mavros and other packages
RUN apt-get update -y \
    && apt-get install -y ros-${ROS_DISTRO}-mavros ros-${ROS_DISTRO}-mavros-extras ros-${ROS_DISTRO}-mavros-msgs \
    && wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh \
    && bash ./install_geographiclib_datasets.sh \
    && apt-get install -y ros-${ROS_DISTRO}-xacro

# Compilation Stage
FROM base AS build

# Create Colcon workspace with external dependencies
RUN mkdir -p /bag_files /asv_ws
WORKDIR /asv_ws
COPY ./dependencies.repos .
RUN vcs import < dependencies.repos \
    && mv ASV_Loyola_US_low_level src \
    && rm dependencies.repos

# Verify Gurobi installation and paths
RUN ls -l /opt/gurobi/linux/lib \
&& echo $CMAKE_PREFIX_PATH \
&& echo $LD_LIBRARY_PATH

# Build the base Colcon workspace, installing dependencies first.
WORKDIR /asv_ws
RUN chmod +x /asv_ws/src/asv_comunication/scripts/transceiver_xbee.py \
    && chmod +x /asv_ws/src/asv_comunication/scripts/xbee_master.py \
    && chmod +x /asv_ws/src/asv_comunication/scripts/xbee_slave.py \
    && /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && apt-get update -y && rosdep update && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y && colcon build --symlink-install --executor sequential"

# Set up environment variables in bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \
    && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc \
    && echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc \
    # && echo "source /asv_ws/install/setup.bash" >> ~/.bashrc \
    && echo "export GUROBI_HOME=/opt/gurobi/linux" >> ~/.bashrc \
    && echo "export PATH=\$GUROBI_HOME/bin:\$PATH" >> ~/.bashrc \
    && echo "export LD_LIBRARY_PATH=\$GUROBI_HOME/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc \
    && echo "export GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic" >> ~/.bashrc \
    && echo "export CMAKE_PREFIX_PATH=\$GUROBI_HOME" >> ~/.bashrc

WORKDIR /bag_files

# launch ros package
#CMD ["ros2", "launch", "asv_bringup", "control_test.launch.py", "my_id:=4"]

# CMD ["ros2", "launch", "asv_bringup", "tu_launch.launch.py", "my_id:=4"]
CMD ["bash"]