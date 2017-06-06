#!/bin/sh -x
if id | grep -qv uid=0; then
    echo "Must run setup as root"
    exit 1
fi

create_socket_dir() {
    local dirname="$1"
    local ownergroup="$2"
    local perms="$3"

    mkdir -p $dirname
    chown $ownergroup $dirname
    chmod $perms $dirname
}

set_perms() {
    local ownergroup="$1"
    local perms="$2"
    local pn="$3"

    chown $ownergroup $pn
    chmod $perms $pn
}

rm -rf /jail
mkdir -p /jail
cp -p index.html /jail

./chroot-copy.sh zookd /jail
./chroot-copy.sh zookfs /jail

#./chroot-copy.sh /bin/bash /jail

./chroot-copy.sh /usr/bin/env /jail
./chroot-copy.sh /usr/bin/python /jail

# to bring in the crypto libraries
./chroot-copy.sh /usr/bin/openssl /jail

mkdir -p /jail/usr/lib /jail/usr/lib/i386-linux-gnu /jail/lib /jail/lib/i386-linux-gnu
cp -r /usr/lib/python2.7 /jail/usr/lib
cp /usr/lib/i386-linux-gnu/libsqlite3.so.0 /jail/usr/lib/i386-linux-gnu
cp /lib/i386-linux-gnu/libnss_dns.so.2 /jail/lib/i386-linux-gnu
cp /lib/i386-linux-gnu/libresolv.so.2 /jail/lib/i386-linux-gnu
cp -r /lib/resolvconf /jail/lib

mkdir -p /jail/usr/local/lib
cp -r /usr/local/lib/python2.7 /jail/usr/local/lib

mkdir -p /jail/etc
cp /etc/localtime /jail/etc/
cp /etc/timezone /jail/etc/
cp /etc/resolv.conf /jail/etc/

mkdir -p /jail/usr/share/zoneinfo
cp -r /usr/share/zoneinfo/America /jail/usr/share/zoneinfo/

create_socket_dir /jail/echosvc 61010:61010 755

mkdir -p /jail/tmp
chmod a+rwxt /jail/tmp

mkdir -p /jail/dev
mknod /jail/dev/urandom c 1 9

cp -r zoobar /jail/
rm -rf /jail/zoobar/db

python /jail/zoobar/zoodb.py init-person
python /jail/zoobar/zoodb.py init-transfer

#set_perms 61012:61012 750 /jail/zoobar/index.cgi
#set_perms 61012:61012 644 /jail/zoobar/auth_client.py
#set_perms 61012:61012 644 /jail/zoobar/auth.py
#set_perms 61012:61012 644 /jail/zoobar/auth.pyc
#set_perms 61012:61012 755 /jail/zoobar/auth_server.py
#set_perms 61012:61012 644 /jail/zoobar/bank.py
#set_perms 61012:61012 644 /jail/zoobar/bank.pyc
#set_perms 61012:61012 755 /jail/zoobar/bank_server.py
#set_perms 61012:61012 755 /jail/zoobar/db
#set_perms 61012:61012 755 /jail/zoobar/db/person
#set_perms 61012:61012 755 /jail/zoobar/db/person/person.db
#set_perms 61012:61012 755 /jail/zoobar/db/transfer
#set_perms 61012:61012 755 /jail/zoobar/db/transfer/transfer.db
#set_perms 61012:61012 644 /jail/zoobar/debug.py
#set_perms 61012:61012 644 /jail/zoobar/debug.pyc
#set_perms 61012:61012 644 /jail/zoobar/echo.py
#set_perms 61012:61012 644 /jail/zoobar/echo.pyc
#set_perms 61012:61012 755 /jail/zoobar/echo_server.py
#set_perms 61012:61012 644 /jail/zoobar/.gitignore
#set_perms 61012:61012 755 /jail/zoobar/index.cgi
#set_perms 61012:61012 644 /jail/zoobar/index.py
#set_perms 61012:61012 644 /jail/zoobar/index.pyc
#set_perms 61012:61012 755 /jail/zoobar/__init__.py
#set_perms 61012:61012 644 /jail/zoobar/__init__.pyc
#set_perms 61012:61012 644 /jail/zoobar/login.py
#set_perms 61012:61012 644 /jail/zoobar/login.pyc
#set_perms 61012:61012 755 /jail/zoobar/media
#set_perms 61012:61012 644 /jail/zoobar/pbkdf2.py
#set_perms 61012:61012 644 /jail/zoobar/profile.py
#set_perms 61012:61012 644 /jail/zoobar/profile.pyc
#set_perms 61012:61012 755 /jail/zoobar/profile_server.py
#set_perms 61012:61012 644 /jail/zoobar/rcplib.py
#set_perms 61012:61012 644 /jail/zoobar/rcplib.pyc
#set_perms 61012:61012 644 /jail/zoobar/sandboxlib.py
#set_perms 61012:61012 755 /jail/zoobar/templates
#set_perms 61012:61012 644 /jail/zoobar/transfer.py
#set_perms 61012:61012 644 /jail/zoobar/transfer.pyc
#set_perms 61012:61012 644 /jail/zoobar/users.py
#set_perms 61012:61012 644 /jail/zoobar/users.pyc
#set_perms 61012:61012 644 /jail/zoobar/.vimrc
#set_perms 61012:61012 644 /jail/zoobar/zoobarjs.py
#set_perms 61012:61012 644 /jail/zoobar/zoobarjs.pyc
#set_perms 61012:61012 644 /jail/zoobar/zoodb.py
#set_perms 61012:61012 644 /jail/zoobar/zoodb.pyc

#static 61013, dynamic 61014
set_perms 61014:61014 750 /jail/zoobar/db
set_perms 61014:61014 750 /jail/zoobar/db/person
set_perms 61014:61014 750 /jail/zoobar/db/person/person.db
set_perms 61014:61014 750 /jail/zoobar/db/transfer
set_perms 61014:61014 750 /jail/zoobar/db/transfer/transfer.db

#stat
set_perms 61013:61013 644 /jail/zoobar/auth_client.py
set_perms 61013:61013 644 /jail/zoobar/auth.py
set_perms 61013:61013 644 /jail/zoobar/auth.pyc

set_perms 61013:61013 754 /jail/zoobar/auth_server.py

#stat
set_perms 61013:61013 644 /jail/zoobar/bank.py
set_perms 61013:61013 644 /jail/zoobar/bank.pyc

set_perms 61013:61013 754 /jail/zoobar/bank_server.py

#stat
set_perms 61013:61013 644 /jail/zoobar/debug.py
set_perms 61013:61013 644 /jail/zoobar/debug.pyc
set_perms 61013:61013 644 /jail/zoobar/echo.py
set_perms 61013:61013 644 /jail/zoobar/echo.pyc

set_perms 61013:61013 754 /jail/zoobar/echo_server.py

#stat
set_perms 61013:61013 644 /jail/zoobar/.gitignore

set_perms 0:61015 755 /jail/zoobar/index.cgi

#stat
set_perms 61013:61013 644 /jail/zoobar/index.py
set_perms 61013:61013 644 /jail/zoobar/index.pyc

set_perms 61013:61013 754 /jail/zoobar/__init__.py

#stat
set_perms 61013:61013 644 /jail/zoobar/__init__.pyc
set_perms 61013:61013 644 /jail/zoobar/login.py
set_perms 61013:61013 644 /jail/zoobar/login.pyc

#dir
set_perms 61013:61013 755 /jail/zoobar/media

#stat
set_perms 61013:61013 644 /jail/zoobar/media/lion_awake.jpg
set_perms 61013:61013 644 /jail/zoobar/media/lion_sleeping.jpg
set_perms 61013:61013 644 /jail/zoobar/media/zoobar.css

#stat
set_perms 61013:61013 644 /jail/zoobar/pbkdf2.py
set_perms 61013:61013 644 /jail/zoobar/profile.py
set_perms 61013:61013 644 /jail/zoobar/profile.pyc

set_perms 61013:61013 754 /jail/zoobar/profile_server.py

#stat
set_perms 61013:61013 644 /jail/zoobar/rcplib.py
set_perms 61013:61013 644 /jail/zoobar/rcplib.pyc
set_perms 61013:61013 644 /jail/zoobar/sandboxlib.py

#dir
set_perms 61013:61013 755 /jail/zoobar/templates

#stat
set_perms 61013:61013 644 /jail/zoobar/transfer.py
set_perms 61013:61013 644 /jail/zoobar/transfer.pyc
set_perms 61013:61013 644 /jail/zoobar/users.py
set_perms 61013:61013 644 /jail/zoobar/users.pyc
set_perms 61013:61013 644 /jail/zoobar/.vimrc
set_perms 61013:61013 644 /jail/zoobar/zoobarjs.py
set_perms 61013:61013 644 /jail/zoobar/zoobarjs.pyc
set_perms 61013:61013 644 /jail/zoobar/zoodb.py
set_perms 61013:61013 644 /jail/zoobar/zoodb.pyc

#argsia vartem
#set_perms 0:61015 755 /jail/usr/bin/python
