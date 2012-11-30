package ContentNegotation::App;

use Catmandu;
use Catmandu::Sane;
use Dancer ':syntax';

use Dancer::Serializer::CSV;

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
  my ($format, $data) = @_;

  given ($format) {

    when ('application/json') {

      # Serialize to JSON
      my $json = to_json $data;

      # Set content-type
      content_type 'application/json';

      return $json;
    };

    when ('text/csv') {

      # Serialize to CSV
      my $s = Dancer::Serializer::CSV->new;
      my $csv = $s->serialize($data);

      # Set content-type
      content_type 'text/csv';

      return $csv;
    };

    when ('text/html') {
      content_type 'text/html';
      return 'html!!!';
    };

    default {
      # unsupported content-type.
      # 406 Not Acceptable
      status 406;
      return;
    };

  };

}

get '/' => sub {

  my $data = {
    firstName => 'wouter',
    lastName => 'willaert',
    age => '21',
  };

  return response_to( prefered_content_type, $data );
};

1;
