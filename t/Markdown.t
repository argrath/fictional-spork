use strict;
use warnings;

use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Markdown') };

use FindBin;
chdir $FindBin::Bin;

{
    my $input = <<EOF

```
ranged
```

EOF
    ;
    my $result = FictionalSpork::Markdown::make_markdown($input);
#    like($result, qr/<code>/, 'entry header');
    like($result, qr/<pre><code>/, 'entry header');
}
