package Dancer::Serializer::CSV;

use Carp;
use Dancer::ModuleLoader;
use Dancer::Exception qw(:all);
use base 'Dancer::Serializer::Abstract';

use Catmandu;
use Catmandu::Sane;

sub serialize {
  my ( $self, $entity ) = @_;

  # shortcut to Catmandu::Importer::CSV with sensible defaults.
  return Catmandu->export_to_string($entity, 'CSV');
}

sub deserialize {
  my ( $self, $content ) = @_;

  my $importer = Catmandu::Importer::CSV->new($content);

  my $data = $importer->to_array;

  defined $data or croak "Couldn't deserialize content '$content'";

  return $data;
}

sub content_type {
  'text/csv'
}


# helpers

sub from_csv {
  my ($csv) = @_;
  my $s = Dancer::Serializer::CSV->new;

  return $s->deserialize($csv);
}

sub to_csv {
  my ($data) = @_;
  my $s = Dancer::Serializer::CSV->new;

  return $s->serialize($data);
}


1;

