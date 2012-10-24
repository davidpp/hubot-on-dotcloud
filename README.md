# Hubot on dotcloud

[hubot](http://hubot.github.com/) with [irc-adapter](https://github.com/nandub/hubot-irc) on [Dotcloud](https://www.dotcloud.com/)

## Usage

Clone:

```sh
$ git clone git://github.com/marsam/hubot-on-dotcloud.git
```

Update hubot configuration in _dotcloud.yml_:

```yaml
hubot:
  name: skynet     # Name of your hubot. "hubot" by default (optional)
  version: 2.3.2   # Version of hubot. latest version by default (optional)
  ports:
    hubot: tcp     # Used for hubot routes
```

Customize the builder, you can add environment variables by your hubot requirements.

Dotcloud magic

```sh
$ dotcloud push hubot hubot-on-dotcloud
```
