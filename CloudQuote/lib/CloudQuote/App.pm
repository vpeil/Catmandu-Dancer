package CloudQuote::App;

use Catmandu::Sane;
use Catmandu::Store::ElasticSearch;

use Dancer ':syntax';
use Dancer::Serializer::CSV;

# Let Dancer handle serialization of perl data structures to JSON.
set serializer => 'mutable';

# Create our ElasticSearch store.
sub store {
  state $store = Catmandu::Store::ElasticSearch->new(
    index_name => 'quotes',
    bags => { 'quote' }
  );
}

# Create our Bag.
sub quotes {
  state $quotes = &store->bag('quote');
}

# DRY
sub _search {
  my ($self, $query) = @_;

  my $results;

  if ($query) {
    $results = quotes->search(query => param('query'))->to_array;
  } else {
    $results = quotes->search()->to_array;
  }

  return $results;
}

## GET /
get '/' => sub {
  template 'index';
};

## GET /new
get '/new' => sub {
  template 'new';
};

prefix '/api' => sub {

  ## GET /api/quotes/search/:query
  get '/quotes/search/:query?' => sub {
    my $results = _search(param('query'));
    $results ? status 200 : status 404;
    return $results;
  };

  ## GET /api/quotes/search/:query/export
  get '/quotes/search/:query?/export' => sub {
    my $results = _search(param('query'));
    $results ? status 200 : status 404;

    ## Serialize to CSV
    my $s = Dancer::Serializer::CSV->new;
    my $csv = $s->serialize($results);

    ## Set content-type
    content_type 'text/csv';

    return $csv;
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

true;
