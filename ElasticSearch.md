## ElasticSearch

Install the binaries using [homebrew](http://mxcl.github.com/homebrew/):

~~~ bash
$ brew install ElasticSearch
~~~

If this is your first install, automatically load ElasticSearch on login with:

~~~ bash
$ mkdir -p ~/Library/LaunchAgents
$ ln -nfs /usr/local/Cellar/elasticsearch/0.19.10/homebrew.mxcl.elasticsearch.plist ~/Library/LaunchAgents/
$ launchctl load -wF ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
~~~

To stop the ElasticSearch daemon:

~~~ bash
$ launchctl unload -wF ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
~~~

To start ElasticSearch manually:

~~~ bash
$ elasticsearch -f -D es.config=/usr/local/Cellar/elasticsearch/0.19.10/config/elasticsearch.yml
~~~

You should see ElasticSearch running:

~~~ bash
$ open http://localhost:9200/
~~~
