#!/bin/sh

CODEROOT=$PWD

HUBOT=${SERVICE_HUBOT_NAME:="hubot"}

node_root=/opt/node

# From https://github.com/dotcloud/node-on-dotcloud
[ "$SERVICE_NODE_VERSION" ] &&
[ "$SERVICE_NODE_VERSION" != "$(node --version)" ] &&
(
    rm -rf $node_root/*
    cd $node_root
    curl -L https://github.com/joyent/node/tarball/$SERVICE_NODE_VERSION | tar -zxf-
    cd joyent-node-*
    ./configure --prefix=$node_root
    make
    make install
)

create_hubot() {
  hubot --create ~/$HUBOT
  cd ~/$HUBOT

  # Adding hubot-irc. If there is a better way let me know
  sed -i -e 's/"dependencies": {/"dependencies": {\n"hubot-hipchat": ">= 1.1.1",/' package.json
  npm update
}


echo "Installing hubot"
npm install -g coffee-script

if [ -n "$SERVICE_HUBOT_VERSION" ]; then
  npm install -g hubot@$SERVICE_HUBOT_VERSION
else
  npm install -g hubot
fi

echo "Creating $HUBOT"
create_hubot

chmod +x ~/$HUBOT/bin/hubot

cat > ~/profile << EOF
## Redis Stuff
export REDISTOGO_URL=\$DOTCLOUD_DATA_REDIS_URL
export PORT=\$PORT_HUBOT

## hubot-hipchat stuff
export HUBOT_HIPCHAT_JID=""
export HUBOT_HIPCHAT_PASSWORD=""

# export HUBOT_LOG_LEVEL="debug"  # This helps to see what Hubot is doing
EOF

cat > ~/run << EOF
#!/bin/sh

cd ~/$HUBOT && bin/hubot --adapter hipchat --name $HUBOT --alias '/'
EOF

chmod +x ~/run

echo "Have fun!!!"
