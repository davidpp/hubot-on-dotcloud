# Hubot-hipchat on dotcloud 

[hubot](http://hubot.github.com/) with [hipchat](https://github.com/nandub/hubot-irc) on [Dotcloud](https://www.dotcloud.com/) forked from [marsam](https://github.com/marsam/hubot-on-dotcloud)

## Usage

Clone:

```sh
$ git clone git://github.com/davidpaquet/hubot-on-dotcloud.git
```

Update hubot configuration in _dotcloud.yml_:

```yaml
data:
  type: redis        # Used for hubot brain.

hubot:               # Hubot service
  # cropped
  hubot:
    name: skynet     # Name of hubot. "hubot" by default (optional)
    version: 2.3.2   # Version of hubot. latest version by default (optional)
    ports:
      hubot: tcp     # Used for hubot routes
```

Customize the builder, you can add environment variables by your hubot requirements.

Dotcloud magic

```sh
$ dotcloud push hubot hubot-on-dotcloud
```
