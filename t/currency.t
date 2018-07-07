use Mojo::Base -strict;
use Test::More;

use_ok 'Currency';

subtest 'insert_cash' => sub {
    my $obj = Currency->new;

    subtest 'coin' => sub {
        my @coins = ( 10, 50, 100 );
        foreach my $coin (@coins) {
            my $total_amount = $obj->total_amount;
            $obj->insert_coin($coin);
            is $obj->total_amount, $total_amount + $coin, 'right insert ' . $coin . 'YEN';
        }
    };

    subtest 'bill' => sub {
        $obj->insert_bill(1000);
        is $obj->total_amount, 1160, 'right insert 1000YEN';
    };
};

subtest 'invalid' => sub {
    my $obj          = Currency->new;
    my $total_amount = $obj->total_amount;

    subtest 'coin' => sub {
        my $stderr;
        local $SIG{__WARN__} = sub { $stderr = shift; };

        my @coins = ( 1, 5 );
        foreach my $coin (@coins) {
            $obj->insert_coin($coin);
            is $obj->total_amount, $total_amount, 'right invalid coin ' . $coin . 'YEN';
            like $stderr, qr/Return coin/, 'right return coin ' . $coin . 'YEN';
        }
    };

    subtest 'bill' => sub {
        my $stderr;
        local $SIG{__WARN__} = sub { $stderr = shift; };

        my @bills = ( 2000, 5000, 10000 );
        foreach my $bill (@bills) {
            $obj->insert_bill($bill);
            is $obj->total_amount, $total_amount, 'right invalid bill ' . $bill . 'YEN';
            like $stderr, qr/Return bill/, 'right return bill ' . $bill . 'YEN';
        }
    };
};

subtest 'refund' => sub {
    my $stderr;
    local $SIG{__WARN__} = sub { $stderr = shift; };

    my $obj = Currency->new;
    $obj->insert_coin(100);
    $obj->insert_coin(10);
    $obj->insert_coin(10);
    $obj->insert_bill(1000);

    is $obj->refund,       1120, 'right refund total amount';
    is $obj->total_amount, 0,    'right reset total amount';
    like $stderr, qr/Refunded/, 'right refund';
};

done_testing();
