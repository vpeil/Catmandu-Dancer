package ContentNegotation::App;
use Catmandu;
use Catmandu::Sane;
use Dancer ':syntax';

use Data::Dumper;

hook before => sub {
  my $accept_header = request->{accept};
  $accept_header =~ s/;.*//g;
  my @accepts = split(',', $accept_header);
  params->{accepts} = \@accepts;
};

sub prefered_content_type {
  my $accepts = params->{accepts};

  state $types = [
    "application/json",
    "text/csv",
    "text/xml",
    "text/html",
  ];

  my $found;
  foreach my $i ( @{$accepts} ) {
    if ( grep $i, @{$types} ) {
      $found = $i;
      last;
    }
  }

  return $found;
}

sub response_to {
  my $format = shift;

  debug $format;

  given ($format) {

    when ('application/json') {
      content_type 'application/json';
      return 'json!!!';
    };

    when ('text/html') {
      content_type 'text/html';
      return 'html!!!';
    };

  };

}

get '/' => sub {
  return response_to( prefered_content_type );
};

1;
