#!/bin/sh

config_path=/config
docker_config_copy=/docker-aria2.conf
downloads_path=/downloads

if [ ! -f $conf_path/aria2.conf ]; then
	cp $docker_config_copy $config_path/aria2.conf
    if [ -n "$RPC_SECRET" ]; then
        printf '\nrpc-secret=%s\n' ${RPC_SECRET} >> $conf_path/aria2.conf
    fi
fi

touch $config_path/aria2.session

if [[ -n "$ARIA2RPCPORT" ]]; then
    echo "Changing rpc request port to $ARIA2RPCPORT"
    sed -i "s/6800/${ARIA2RPCPORT}/g" /usr/local/www/ariang/js/aria-ng*.js
fi

userid="$(id -u)" # 65534 - nobody, 0 - root
groupid="$(id -g)"

if [[ -n "$PUID" && -n  "$PGID" ]]; then
    echo "Running as user $PUID:$PGID"
    userid=$PUID
    groupid=$PGID
fi

chown -R $userid:$groupid $config_path
chown -R $userid:$groupid $downloads_path

caddy -quiet -conf /usr/local/caddy/Caddyfile &
su-exec $userid:$groupid aria2c --conf-path="$config_path/aria2.conf"
