on 'configure' => sub {
  requires 'Module::Build', '0.40';
  requires 'Module::Build::Pluggable::CPANfile', '0.04';
};

on 'build' => sub {
  requires 'Module::Build::Pluggable::CPANfile', '0.04';
};

requires 'YAML::Tiny';
requires 'Template';
requires 'Text::MultiMarkdown';
requires 'XML::FeedPP';
