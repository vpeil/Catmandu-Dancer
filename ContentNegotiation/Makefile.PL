use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'ContentNegotation::App',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/ContentNegotation/App.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.311,
        'Catmandu'   => 0.0401,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ContentNegotation-App-*' },
);
