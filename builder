#!/bin/sh

CODEROOT=$PWD

my_hubot="$SERVICE_MY_HUBOT"
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


# This allows install with -g option
echo "prefix = ~/.node" > ~/.npmrc
export PATH=$PATH:$HOME/.node/bin

install_hubot(){
  [ -d ~/hubot ] || ( cd ~ && git clone git://github.com/github/hubot.git )
  cd ~/hubot
  npm install -g coffee-script
  npm install -g
}

create_my_hubot() {
  hubot --create ~/$my_hubot
  cd ~/$my_hubot

  # Adding hubot-irc. If there is a better way let me know
  sed -i -e 's/"dependencies": {/"dependencies": {\n"hubot-irc": ">= 0.0.6",/' package.json
  npm update
}


echo "Installing hubot"
install_hubot

echo "Creating $my_hubot"
create_my_hubot

chmod +x ~/$my_hubot/node_modules/hubot/bin/hubot

# Customize this
cat > ~/run << EOF
#!/bin/sh

## hubot-irc stuff
export HUBOT_IRC_SERVER="irc.freenode.net"
export HUBOT_IRC_ROOMS="#hubot,#hubot-irc"
export HUBOT_IRC_PASSWORD=""
export HUBOT_IRC_NICK="$my_hubot"
# export HUBOT_LOG_LEVEL="debug"  # This helps to see what Hubot is doing
# export HUBOT_IRC_DEBUG="true"

## Redis Stuff
export REDISTOGO_URL=\$DOTCLOUD_DATA_REDIS_URL

export PATH=~/$my_hubot/node_modules/.bin:~/$my_hubot/node_modules/hubot/node_modules/.bin:~/.node/bin:$PATH

cd ~/$my_hubot && ./node_modules/hubot/bin/hubot --adapter irc
EOF

chmod +x ~/run

echo "Have fun!!!"
