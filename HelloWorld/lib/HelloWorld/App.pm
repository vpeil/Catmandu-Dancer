package HelloWorld::App;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/about' => sub {
    template 'about';
};

get '/contact' => sub {
    template 'contact';
};


true;
