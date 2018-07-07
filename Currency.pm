package Currency;
use Mojo::Base -base;

has total_amount => 0;

sub insert_cash {
    my ( $self, $amount ) = @_;
    my $total_amount = $self->total_amount;
    $total_amount += $amount;
    $self->total_amount($total_amount);
}

sub insert_coin {
    my ( $self, $amount ) = @_;

    return warn 'Return coin ' . $amount . 'YEN'
      if $amount != 10
      and $amount != 50
      and $amount != 100
      and $amount != 500;
    $self->insert_cash($amount);
}

sub insert_bill {
    my ( $self, $amount ) = @_;

    return warn 'Return bill ' . $amount . 'YEN' if $amount != 1000;
    $self->insert_cash($amount);
}

sub refund {
    my $self = shift;

    my $total_amount = $self->total_amount;
    $self->total_amount(0);

    warn 'Refunded ' . $total_amount . 'YEN';
    return $total_amount;
}

1;
