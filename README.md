# Pragmatic Catmandu and Dancer

## A Gentle introduction to Dancer

Dancer is a simple but powerful micro-framework for building web applications in Perl. It is inspired by the Sinatra framework from the Ruby world. Dancer is build on top of Plack and offers a higher level api which gets you up and running in no time. For more information about Dancer, refer to [http://perldancer.org/](http://perldancer.org/).

PS, Dancer is a opensource project, take a look at the source code hosted on Github: [https://github.com/PerlDancer/Dancer](https://github.com/PerlDancer/Dancer).

### Getting Started

#### Installing Dancer

The easiest way to get up and running with Dancer is to install it using cpanminus:

```shell
$ curl -L http://cpanmin.us | perl - --sudo Dancer
```

This command will install cpanminus first and use it to install Dancer. If you already have cpanminus installed on your system, simply run:

```shell
$ cpanm Dancer
```

#### Creating your first application

To create a new Dancer application, use the ```dancer``` executable which is provided out of the box. This cli tool provides a simple way to get an application skeleton going. Be sure to check out the ```--help```:

```shell
Usage:
    dancer [options] -a <appname>

Options:
        -h, --help            : print what you are currently reading
        -a, --application     : the name of your application
        -p, --path            : the path where to create your application
                                  (current directory if not specified)
        -x, --no-check        : don't check for the latest version of Dancer
                                  (checking version implies internet connection)
        -v, --version         : print the version of dancer being used
```

Let's generate our first Dancer application, feel free to replace ```MyWeb::App``` with whatever suites you:

```shell
$ dancer -a MyWeb::App
+ MyWeb-App
+ MyWeb-App/bin
+ MyWeb-App/bin/app.pl
+ MyWeb-App/config.yml
+ MyWeb-App/environments
+ MyWeb-App/environments/development.yml
+ MyWeb-App/environments/production.yml
+ MyWeb-App/views
+ MyWeb-App/views/index.tt
+ MyWeb-App/views/layouts
+ MyWeb-App/views/layouts/main.tt
+ MyWeb-App/MANIFEST.SKIP
+ MyWeb-App/lib
+ MyWeb-App/lib/MyWeb
+ MyWeb-App/lib/MyWeb/App.pm
+ MyWeb-App/public
+ MyWeb-App/public/css
+ MyWeb-App/public/css/style.css
+ MyWeb-App/public/css/error.css
+ MyWeb-App/public/images
+ MyWeb-App/public/500.html
+ MyWeb-App/public/404.html
+ MyWeb-App/public/dispatch.fcgi
+ MyWeb-App/public/dispatch.cgi
+ MyWeb-App/public/javascripts
+ MyWeb-App/public/javascripts/jquery.js
+ MyWeb-App/t
+ MyWeb-App/t/002_index_route.t
+ MyWeb-App/t/001_base.t
+ MyWeb-App/Makefile.PL
```

It generated a working dancer application, let's run the application:

```shell
$ cd MyWeb-App
./bin/app.pl
>> Dancer server 16622 listening on http://0.0.0.0:3000
== Entering the development dance floor ...
```

Check it out in your favorite browser:

```shell
$ open http://0.0.0.0:3000/
```

That's all you need to get a simple application up and running.

#### Extending our application

Let's take a look at the code for this application located in the ```lib``` folder:

```shell
$ cd lib/MyWeb
```

Open the ```App.pm``` file in your editor. This is what you'll see:

```perl
package MyWeb::App;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

true;
```

When ```Dancer``` is imported to a script, that script becomes a webapp, and at this point, all the script has to do is declare a list of routes. A route handler is composed by an HTTP method, a path pattern and a code block. The available HTTP method keywords are ```get```, ```post```, ```put``` and ```del```.

Let's add a custom route:

```perl
get '/hello/:name' => sub {
    return 'Hello '.param('name');
};
```

All GET requests that match the path ```/hello/*``` will execute this code block and return ```Hello ``` followed by everything after the second ```/```.

See it for yourself:

```shell
$ cd MyWeb-App
./bin/app.pl
>> Dancer server 16622 listening on http://0.0.0.0:3000
== Entering the development dance floor ...
```

```shell
$ curl http://0.0.0.0:3000/hello/world
Hello world
```

In the above case we're simply rendering a string, but how to we render a page using a layout and a template? Luckily, Dancer support multiple templating engines. By default it uses a very basic template engine called ```simple```. Let's switch to [Template Toolkit](http://template-toolkit.org/), a more featureful templating engine.

Tell ```Dancer``` to use ```Template Toolkit``` by editing your ```config.yml``` file to resemble this one:

```perl
# This is the main configuration file of your Dancer app
# env-related settings should go to environments/$env.yml
# all the settings in this file will be loaded at Dancer's startup.

# Your application's name
appname: "MyWeb::App"

# The default layout to use for your application (located in
# views/layouts/main.tt)
layout: "main"

# when the charset is set to UTF-8 Dancer will handle for you
# all the magic of encoding and decoding. You should not care
# about unicode within your app when this setting is set (recommended).
charset: "UTF-8"

template: "template_toolkit"
engines:
   template_toolkit:
     encoding:  'utf8'
     start_tag: '[%'
     end_tag:   '%]'
```

With Template Toolkit ready to use, let's create our layout template. All template live under the ```./views/``` directory. A layout is a special view, located in the ```layouts``` directory (inside the views directory) which must have a token named `content'. That token marks the place where to render the action view. This lets you define a global layout for your actions. Any tokens that you defined when you called the 'template' keyword are available in the layouts, as well as the standard session, request, and params tokens. This allows you to insert per-page content into the HTML boilerplate, such as page titles, current-page tags for navigation, etc.

Here is an example of a layout: ```views/layouts/main.tt```:

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>[% title %]</title>
    </head>
    <body>
        <header>
            <h1>[% title %]</h1>
        </header>

        <div id="content">
            [% content %]
        </div>

        <footer>
            <small>Copyright &copy; 2012</small>
        </footer>

    </body>
</html>
```

Here is an example of view: ```views/index.tt```:

```html
<p>Hello from index.tt</p>
```

This layout can be used like this following:

```perl
get '/' => sub {
    template 'index' => {
        title => "Home"
    };
};
```

The default location for static files such as images, stylesheets and javascripts is ```./public/```. Static files can be accessed from the base url. For example, css file located at ```/public/css/styles.css``` is accessible from the url ```http://0.0.0.0:3000/css/styles.css```.

For a more in depth introduction to Dancer, visit: [Dancer::Introduction](https://metacpan.org/module/Dancer::Introduction) and [Dancer::Tutorial](https://metacpan.org/module/Dancer::Tutorial).

## A Gentle introduction to Catmandu

Catmandu provides a suite of Perl modules to ease the import, storage, retrieval, export and transformation of metadata records. Combine Catmandu modules with web application frameworks such as PSGI/Plack, document stores such as [MongoDB](http://www.mongodb.org/) and full text indexes as [Solr](http://lucene.apache.org/solr/) to create a rapid development environment for digital library services such as institutional repositories and search engines.

For an overview of the Catmandu platform visit the [Catmandu Programmers Guide](http://librecat.org/tutorial/index.html).

Let's use ```Catmandu::Store::ElasticSearch``` to connect our Dancer application with a [ElastichSearch](http://www.elasticsearch.org/) engine.

### Using the dancat generator

Using dancat you can easily scaffold a basic Dancer application that makes use of the Catmandu framework:

```bash
$ dancat -h

Usage:
    dancat [options] -a <appname>

Options:
    -h, --help            : output usage information
    -v, --version         : output the Dancer version number
    -a, --application     : the name of your application
    -p, --path            : the path where to create your application. Defaults to current directory.
    -s, --store           : the catmandu store to use. Options are [dbi|elasticsearch|hash|solr]
    -t, --template        : the template engine to use. Options are [tt|simple]
    -x, --no-check        : don't check for the latest version of Dancer

Usage:
    $ dancat -s ElasticSearch -t TemplateToolkit -a MyWeb::App
    $ cd MyWeb-App
    $ ./bin/app.pl
```

Let's scaffold a basic Dancer application that uses the Catmandu framework for accessing a ElasticSearch store.

```bash
$ dancat -s ElasticSearch -t tt -a CloudQuote::App

+ CloudQuote
+ CloudQuote/bin
+ CloudQuote/bin/app.pl
+ CloudQuote/catmandu.yml
+ CloudQuote/config.yml
+ CloudQuote/environments
+ CloudQuote/environments/development.yml
+ CloudQuote/environments/production.yml
+ CloudQuote/views
+ CloudQuote/views/index.tt
+ CloudQuote/views/layouts
+ CloudQuote/views/layouts/main.tt
+ CloudQuote/MANIFEST.SKIP
+ CloudQuote/public
+ CloudQuote/public/css
+ CloudQuote/public/css/main.css
+ CloudQuote/public/js
+ CloudQuote/public/js/main.js
+ CloudQuote/public/dispatch.fcgi
+ CloudQuote/public/img
+ CloudQuote/public/dispatch.cgi
+ CloudQuote/lib
+ CloudQuote/lib/Test
+ CloudQuote/lib/Test/App.pm
+ CloudQuote/t
+ CloudQuote/t/002_index_route.t
+ CloudQuote/t/001_base.t
+ CloudQuote/Makefile.PL
```

The above command will give us a basic Dancer application with a basic Catmandu setup. We get HTML5, [TemplateToolkit](http://www.template-toolkit.org/) and Catmandu out of the box.

### Exposing a HTTP API using Dancer and Catmandu

Let's extend the scaffolded Dancer application to expose a simple (restful-ish) HTTP API. Our goal is to build a simple application that stores quotes and make them searchable.

We will be using ElasticSearch for store and searching our data, Dancer for exposing a JSON HTTP API
and finaly some Backbone.js to consume this API.

First we'll have a look what the generater gives us:

The most important file for the Catmandu framework is the ```catmandu.yml``` configuration file.

```yaml
store:
  default:
    package: ElasticSearch

exporter:
  default:
    package: JSON
```

This file is loaded by the Catmandu framework at startup and contains some configuration.
In this case we tell it it should use ```ElasticSearch``` store by default.
We can easily define multiple data stores in this file.

It's possible to further configure our ElasticSearch store in this config file:

```yaml
store:
  default:
    package: ElasticSearch
    options:
        index_name: qoutes
        bags:
            qoutes: {}
...
```

We could go even further and define a schema for ```quotes```.

Once we've configured Catmandu, we're ready to use the store:

```perl
use Catmandu;

...

# loading the default store.
sub myStore {
    state $bag = Catmandu->store->bag;
}

# somewhere else
$self->myStore->search(%args);
```

When we have multiple stores defined in the ```catmandu.yml```, other than the default store,
we have to tell Catmandu which store to use: ```Catmandu->store('name-defined-in-config-file')->bag;```.

If we don't have a configuration file, we could explicitly tell Catmandu which store to use:

```perl
# Create our ElasticSearch store.
sub store {
  state $store = Catmandu::Store::ElasticSearch->new(
    index_name => 'quotes',
    bags => { 'quote' => {} }
  );
}

# Create our Bag.
sub quotes {
  state $quotes = &store->bag('quote');
}
```

A ```Catmandu::Bag``` is the equivalent of a table in a RDBMS.

Let's have a look at the API for a ```Catmandu::Bag```:

* ```search```: searches the store, if the store is searchable.

* ```get```: retrieves a record by id.

* ```add```: addes a record to the bag, auto-generates an id. When an id is defined, it will update the existing record.

* ```delete```: deletes a record from a bag.

* ```commit```: commits changes to the store.

This is all we need to define our CRUD interface. We just need to define some Dancer routes.

```perl
prefix '/api' => sub {

  ## GET /api/quotes/search/:query
  get '/quotes/search/:query' => sub {
    my $results = quotes->search(query => param('query'))->to_array;

    $results ? status 200 : status 404;
    return $results;
  };

  # ...

};
```

The Dancer ```prefix``` function allows us to prefix routes. In this case we are prefixing all routes
with ```/api```.

Thanks to the ```Dancer::Serializer``` we don't have to worry about serializing to json. We can just retur an array of records and Dancer will handle the rest.

You can configure the serializer in the ```config.yml``` file or explicilty tell it what to do in ```lib/CloudQuote/App.pm``` file:

```perl
# Let Dancer handle serialization of perl data structures to JSON.
set serializer => 'json';
```

Using ```set serializer => 'mutable';``` Dancer will automaticly use the apropiate serializer.
e.g. when returning an array it will serialize it to JSON.

```perl
prefix '/api' => sub {

  ## GET /api/quotes/search/:query
  get '/quotes/search/:query' => sub {
    my $results = quotes->search(query => param('query'))->to_array;

    $results ? status 200 : status 404;
    return $results;
  };

  get '/quotes' => sub {
    my $results = quotes->search()->to_array;

    $results ? status 200 : status 404;
    return $results;
  };

  ## GET /api/quotes/5
  get '/quotes/:id' => sub {
    my $result = quotes->get(param('id'));

    $result ? status 200 : status 404;
    return $result;
  };

  ## POST /api/quotes
  post '/quotes' => sub {
    my $post_params = params('body');

    my $quote = quotes->add({
      author => $post_params->{'author'},
      quote => $post_params->{'quote'}
    });

    if (my ($res) = quotes->commit) { status 200 }
    else { status 500 };

    return;
  };

  ## PUT /api/quotes/5
  put 'quotes/:id' => sub {
    my $post_params = params('body');

    my $quote = quotes->add({
      _id => param('id'),
      author => $post_params->{'author'},
      quote => $post_params->{'quote'}
    });

    if (my ($res) = quotes->commit) { status 200 }
    else { status 500 };

    return;
  };

  ## DEL /api/quotes/5
  del 'quotes/:id' => sub {
    quotes->delete(param('id'));

    if (my ($res) = quotes->commit) { status 200 }
    else { status 500 };

    return;
  };

};
```


## Summary

