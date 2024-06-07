#!/bin/bash

docker run -i --rm -v "$PWD":/out -w /root alpine /bin/sh <<EOF
apk add gcc make musl-dev ncurses-static curl jq unzip
name=$(curl -s "https://api.github.com/repos/vim/vim/tags" | jq '.[0]')
version=$(echo "$tag" | jq -r '.name')
url=$(echo "$tag" | jq -r '.zipball_url')
wget "$url"
unzip "$name"
cd "$name"
LDFLAGS="-static" ./configure --disable-channel --disable-gpm --disable-gtktest --disable-gui --disable-netbeans --disable-nls --disable-selinux --disable-smack --disable-sysmouse --disable-xsmp --enable-multibyte --with-features=huge --without-x --with-tlib=ncursesw
make
make install
mkdir -p /out/vim
cp -r /usr/local/* /out/vim
strip /out/bin/vim
chown -R $(id -u):$(id -g) /out/vim
EOF
