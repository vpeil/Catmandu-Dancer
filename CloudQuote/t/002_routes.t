use Test::More tests => 12;
use strict;
use warnings;

use CloudQuote::App;
use Dancer::Test;

# GET / ------------------------------------------------------------------------

route_exists [GET => '/'], 'a route handler is defined for GET /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';


# POST /api/quotes -------------------------------------------------------------

route_exists [POST => '/api/quotes'],
             'a route handler is defined for POST /api/quotes';

my $response = dancer_response POST => '/api/quotes';
is $response->{status}, 202, 'response for POST /api/quotes is 202';
is $response->{content}, '', 'response content looks good for POST /api/quotes';


# GET /api/quotes/search/lance -------------------------------------------------

route_exists [GET => '/api/qoutes/search'],
             'a route handler is defined for GET /api/quotes/search';

response_status_is ['GET' => '/'], 200, 'response status is 200 for /';


# GET /api/quotes/123456 -------------------------------------------------------

route_exists [GET => '/api/quotes'],
             'a route handler is defined for GET /api/quotes';

response_status_is ['GET' => '/'], 200, 'response status is 200 for /';


# PUT /api/quotes/123456 -------------------------------------------------------

route_exists [PUT => '/api/quotes'],
             'a route handler is defined for PUT /api/quotes';




# DEL /api/quotes/123456 -------------------------------------------------------

route_exists [DEL => '/api/quotes'], 'a route handler is defined for DEL /api/quotes';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';
