use Module::Build;
use Module::Build::Pluggable qw(
    CPANfile
);

my $build = Module::Build::Pluggable->new
  (
   module_name => 'FictionalSpork',
   license  => 'perl',
   dist_author => 'SHIRAKATA Kentaro <argrath@ub32.org>',
   dist_version_from => 'fs.pl',
   dist_abstract => 'fs.pl',
  );
$build->create_build_script;
