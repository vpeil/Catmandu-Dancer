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
