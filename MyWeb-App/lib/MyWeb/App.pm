package MyWeb::App;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/hello/:name' => sub {
  return 'Hello '.param('name');
};

true;
