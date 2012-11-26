## ElasticSearch

Install the binaries using [homebrew](http://mxcl.github.com/homebrew/):

    ```shell
    $ brew install ElasticSearch
    ```

If this is your first install, automatically load ElasticSearch on login with:

    ```shell
    $ mkdir -p ~/Library/LaunchAgents
    $ ln -nfs /usr/local/Cellar/elasticsearch/0.19.10/homebrew.mxcl.elasticsearch.plist ~/Library/LaunchAgents/
    $ launchctl load -wF ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
    ```

To stop the ElasticSearch daemon:

    ```shell
    $ launchctl unload -wF ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
    ```

To start ElasticSearch manually:

    ```shell
    $ elasticsearch -f -D es.config=/usr/local/Cellar/elasticsearch/0.19.10/config/elasticsearch.yml
    ```

You should see ElasticSearch running:

    ```shell
    $ open http://localhost:9200/
    ```
