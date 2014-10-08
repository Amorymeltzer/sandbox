#!/usr/bin/env perl -w
#####################################################
### Copyright (c) 2002 Russell B Cecala. All rights
### reserved.  This program is free software; you can
### redistribute it and/or modify it under the same 
### terms as Perl itself.
#####################################################

use strict;
use lib ('.');

use Tk;
use Tk::Canvas;
use Math::Trig;
use Vector2D;
use Viewport;
use Clip2;
use Getopt::Std;

my $width = 500;
my $height = 500;
my $background = 'blue';
my $fill = 'yellow';
my $initialX= 0;
my $initialY= 800;
my $gravity = new Vector2D(0, 1.62);
my $acceleration = new Vector2D(0, 20.0);
my $LanderVelocity = new Vector2D(0, 0 );
my $staticWindow = 0;
my $crashSpeed = 10.0;
my $crashSlope = 0.0;
my $fuel = 20;

my %opts = ();
getopts( 'W:H:b:f:F:g:x:y:X:Y:a:c:s:Sh', \%opts );
if( $opts{W} ) { $width = $opts{W} ; }
if( $opts{H} ) { $height = $opts{H} ; }
if( $opts{b} ) { $background = $opts{b} ; }
if( $opts{f} ) { $fill = $opts{f} ; }
if( $opts{F} ) { $fuel = $opts{F} ; }
if( $opts{x} ) { $initialX = $opts{x} ; }
if( $opts{y} ) { $initialY = $opts{y} ; }
if( $opts{g} ) { $gravity       ->sety ($opts{g}) ; }
if( $opts{a} ) { $acceleration  ->sety ($opts{a}) ; }
if( $opts{X} ) { $LanderVelocity->setx ($opts{X}) ; }
if( $opts{Y} ) { $LanderVelocity->sety ($opts{Y}) ; }
if( $opts{c} ) { $crashSpeed = $opts{c}; }
if( $opts{s} ) { $crashSlope = $opts{s}; }
if( $opts{S} ) { $staticWindow = 1; }
if( $opts{h} ) { &usage; exit;}

sub usage {
    print <<USAGE;
    -W <canvas width>Default is 500
	-H <canvas height>Default is 500
	-b <background color>Default is blue
	-f <foreground color>Default is yellow
	-F <fuel>Default is 20
	-x <initail x position>Default is 0
	-y <initail y position>Default is 800
	-g <gravity>Default is 1.62 (the moon)
	-a <engine thrust>Default is 20
	-X <initail X velocity> Default is 0
	-Y <initail Y velocity> Default is 0
	-c <crash velocity> Default is 10
	-s <landing slope tolerance> Default is 0
	-S do not resize scene (ship may leave screen)
	-h print this message

	How to play:

	pressing 'k' fires main thruster.
	pressing 'j' rotates lander counter-clockwise
	pressing 'l' rotates lander clockwise
	pressing 'r' restarts the game.

	Place g in m/sec2  
	----------------
	Moon         1.62
	Mercury         3.58
	Venus         8.87
	Earth9.8
	Mars         3.74
	Jupiter        26.01
	Saturn         11.17
	Uranus         10.49
	Neptune        13.25
	Pluto           0.73
USAGE
}

my @LandScape = (
		 new Vector2D(  -800,   40 ), #pt  0
		 new Vector2D(  -500,   50 ), #pt  1
		 new Vector2D(  -400,   50 ), #pt  2
		 new Vector2D(  -300,  100 ), #pt  3
		 new Vector2D(  -100,    0 ), #pt  4
		 new Vector2D(   100,    0 ), #pt  5
		 new Vector2D(   150,   75 ), #pt  7
		 new Vector2D(   300,   75 ), #pt  8
		 new Vector2D(   400,  300 ), #pt  9
		 new Vector2D(   450,  100 ), #pt 10
		 new Vector2D(   800,    0 ), #pt 11
		 );

my @Lander = (
	      new Vector2D(  0 + $initialX,   0 + $initialY), #pt 0
	      new Vector2D( 10 + $initialX,   0 + $initialY), #pt 1
	      new Vector2D(  5 + $initialX,   0 + $initialY), #pt 2
	      new Vector2D( 10 + $initialX,  10 + $initialY), #pt 3
	      new Vector2D( 20 + $initialX,  20 + $initialY), #pt 4
	      new Vector2D( 40 + $initialX,  20 + $initialY), #pt 5
	      new Vector2D( 50 + $initialX,  10 + $initialY), #pt 6
	      new Vector2D( 55 + $initialX,   0 + $initialY), #pt 7
	      new Vector2D( 50 + $initialX,   0 + $initialY), #pt 8
	      new Vector2D( 60 + $initialX,   0 + $initialY), #pt 9
	      new Vector2D( 55 + $initialX,  30 + $initialY), #pt 10
	      new Vector2D( 55 + $initialX,  40 + $initialY), #pt 11
	      new Vector2D( 40 + $initialX,  50 + $initialY), #pt 12
	      new Vector2D( 20 + $initialX,  50 + $initialY), #pt 13
	      new Vector2D(  5 + $initialX,  40 + $initialY), #pt 14
	      new Vector2D(  5 + $initialX,  30 + $initialY), #pt 15
	      new Vector2D( 30 + $initialX, -40 + $initialY), #thruster flame pt 16
	      new Vector2D( 30 + $initialX,  25 + $initialY)  #center of gravity pt 17
	      );

my $top = MainWindow->new();
my $can = $top->Canvas( 
			-width => $width, 
			-height=> $height,
			-background => $background  )->form();

my $x_max = $width;
my $y_max = $height;
my $x_min = 5;
my $y_min = 5;
my $x_center = $can->reqwidth()/2.0;
my $y_center = $can->reqheight()/2.0;

my $pi= 4 * atan(1.0);
my $phi = $pi/15.0;

my $cosphi = cos ( $phi );
my $sinphi = sin ( $phi );
my $center = new Vector2D( $x_center, $y_center );
my $r_max = $can->reqwidth()/2;
my $start = $center->plus( new Vector2D( 0.9 * $r_max, 0 ) );
my $vp = new Viewport();
my $clipbox = new Clip2();

### set up Keys
sub rPressed { ### Restart game
    $can->delete( 'Lander' );
    $can->delete( 'crash' );
    &initializeLander;
    $vp->resetwindow();
    foreach my $v ( @Lander ) { 
	$vp->updatewindowboundaries( $v->getx(), $v->gety() ); 
    }
    foreach my $v ( @LandScape ) { 
	$vp->updatewindowboundaries( $v->getx(), $v->gety() ); 
    }
    $vp->viewportboundaries ( $x_min, $x_max, $y_min, $y_max, 0.9 );
    &play;
}

sub kPressed { ### Fire Thruster
    #Draw Thruster Flame
    if ( $fuel-- > 0 ) {
	&drawThrusterFlame;
	$LanderVelocity->incr( $acceleration );
    } else {
	print "Out of gas!!!!\n";
    }
    Ev('k');
}
sub lPressed { ### Rotate clockwise
    &rotateLanderCounterClockwise;
    Ev('l');
}

sub jPressed { ### Rotate clockwise
    &rotateLanderClockwise;
    Ev('j');
}

$top->bind( '<Key-k>',  \&kPressed );
$top->bind( '<Key-l>',  \&lPressed );
$top->bind( '<Key-j>',  \&jPressed );
$top->bind( '<Key-r>',  \&rPressed );
### set up window
foreach my $v ( @Lander ) {
    $vp->updatewindowboundaries( $v->getx(), $v->gety() );
}
foreach my $v ( @LandScape ) {
    $vp->updatewindowboundaries( $v->getx(), $v->gety() );
}
$vp->viewportboundaries ( $x_min, $x_max, $y_min, $y_max, 0.9 );

&drawLander;
&drawLandScape;
$can->after( 100, \&play );
MainLoop;

sub rotateLanderClockwise {
    ### $Lander[17] is Lander's center of gravity
    foreach my $v ( @Lander ) {
	$v = $v->rotate( $Lander[17], $cosphi, $sinphi );
    }
    $acceleration = $acceleration->rotate( 
					   new Vector2D( 0.0, 0.0), $cosphi, $sinphi 
					   );
}

sub rotateLanderCounterClockwise {
    ### $Lander[17] is Lander's center of gravity
    foreach my $v ( @Lander ) {
	$v = $v->rotate( $Lander[17], $cosphi, -$sinphi );
    }
    $acceleration = $acceleration->rotate( 
					   new Vector2D( 0.0,0.0), $cosphi, -$sinphi 
					   );
}


sub moveLander {
    # The Physics: 
    # xt = x0 + v0t +    0 + $initialY), #pt 0
    new Vector2D( 10 + $initialX,   0 + $initialY), #pt 1
    new Vector2D(  5 + $initialX,   0 + $initialY), #pt 2
    new Vector2D( 10 + $initialX,  10 + $initialY), #pt 3
    new Vector2D( 20 + $initialX,  20 + $initialY), #pt 4
    new Vector2D( 40 + $initialX,  20 + $initialY), #pt 5
    new Vector2D( 50 + $initialX,  10 + $initialY), #pt 6
    new Vector2D( 55 + $initialX,   0 + $initialY), #pt 7
    new Vector2D( 50 + $initialX,   0 + $initialY), #pt 8
    new Vector2D( 60 + $initialX,   0 + $initialY), #pt 9
    new Vector2D( 55 + $initialX,  30 + $initialY), #pt 10
    new Vector2D( 55 + $initialX,  40 + $initialY), #pt 11
    new Vector2D( 40 + $initialX,  50 + $initialY), #pt 12
    new Vector2D( 20 + $initialX,  50 + $initialY), #pt 13
    new Vector2D(  5 + $initialX,  40 + $initialY), #pt 14
    new Vector2D(  5 + $initialX,  30 + $initialY), #pt 15
    new Vector2D( 30 + $initialX, -40 + $initialY), #thruster flame pt 16
    new Vector2D( 30 + $initialX,  25 + $initialY)  #center of gravity pt 17
	);
$LanderVelocity = new Vector2D(0, 0 );
$fuel = 20;
$acceleration = new Vector2D(0, 20.0);

if( $opts{F} ) { $fuel = $opts{F} ; }
if( $opts{X} ) { $LanderVelocity->setx ($opts{X}) ; }
if( $opts{Y} ) { $LanderVelocity->sety ($opts{Y}) ; }
if( $opts{a} ) { $acceleration  ->sety ($opts{a}) ; }
}

sub drawCrash {
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   -fill => 'red',
		   -tag  => 'crash',
		   -width => 5
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   -fill => 'red',
		   -tag  => 'crash',
		   -width => 5
		   );
}

sub drawClipBox {
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   -fill => $fill,
		   -tag  => 'clipbox'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   -fill => $fill,
		   -tag  => 'clipbox'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymax()), 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   -fill => $fill,
		   -tag  => 'clipbox'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($clipbox->getxmax()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   $vp->x_viewport($clipbox->getxmin()), 
		   $vp->y_viewport($clipbox->getymin()), 
		   -fill => $fill,
		   -tag  => 'clipbox'
		   );
}

sub touchDown {
    my $clipped = 0;
    my $lineSlope = 0;
    my ( $x1, $y1, $x2, $y2 );
    for ( my $i=0; $i<$#LandScape and $clipped == 0 ; $i++ ) {
	$x1 = $LandScape[$i]->getx();
	$y1 = $LandScape[$i]->gety();
	$x2 = $LandScape[$i+1]->getx();
	$y2 = $LandScape[$i+1]->gety();
	$clipped = $clipbox->cliped( $x1, $y1, $x2, $y2 ); 
	$lineSlope = ($y2 - $y1)/($x2 - $x1);
    }
    if ( $clipped == 1 ) {
	### calulate the speed at impact
	my $speed = sqrt( 
			  $LanderVelocity->getx() * $LanderVelocity->getx() + 
			  $LanderVelocity->gety() * $LanderVelocity->gety());
	print "landing speed is $speed\n" .
	    "Line slope $lineSlope\n";
	if ( $speed >= $crashSpeed ) { 
	    return -1;
	} else {
	    if ( -$crashSlope <= $lineSlope && 
		 $lineSlope <= $crashSlope ) {
		return  1;
	    } else {
		return -1;
	    }
	}
    } 
    return 0;
}

sub drawThrusterFlame {
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[4]->getx()), 
		   $vp->y_viewport($Lander[4]->gety()), 
		   $vp->x_viewport($Lander[16]->getx()), 
		   $vp->y_viewport($Lander[16]->gety()), 
		   -fill => $fill,
		   -tag  => ['Flame', 'Lander']
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[16]->getx()), 
		   $vp->y_viewport($Lander[16]->gety()), 
		   $vp->x_viewport($Lander[5]->getx()), 
		   $vp->y_viewport($Lander[5]->gety()), 
		   -fill => $fill,
		   -tag  => ['Flame', 'Lander']
		   );
}


sub drawLandScape {
    $can->delete( 'LandScape' );
    my $start_x = $LandScape[0]->getx();
    my $start_y = $LandScape[0]->gety();
    for my $v ( @LandScape ) {
	$can->create ( 'line', 
		       $vp->x_viewport($start_x), 
		       $vp->y_viewport($start_y), 
		       $vp->x_viewport($v->getx()), 
		       $vp->y_viewport($v->gety()), 
		       -fill => $fill,
		       -tag  => 'LandScape'
		       );
	$start_x = $v->getx();
	$start_y = $v->gety();
    };
}

sub drawLander {
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[0]->getx()), 
		   $vp->y_viewport($Lander[0]->gety()), 
		   $vp->x_viewport($Lander[1]->getx()), 
		   $vp->y_viewport($Lander[1]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[2]->getx()), 
		   $vp->y_viewport($Lander[2]->gety()), 
		   $vp->x_viewport($Lander[3]->getx()), 
		   $vp->y_viewport($Lander[3]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[3]->getx()), 
		   $vp->y_viewport($Lander[3]->gety()), 
		   $vp->x_viewport($Lander[4]->getx()), 
		   $vp->y_viewport($Lander[4]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[4]->getx()), 
		   $vp->y_viewport($Lander[4]->gety()), 
		   $vp->x_viewport($Lander[5]->getx()), 
		   $vp->y_viewport($Lander[5]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[5]->getx()), 
		   $vp->y_viewport($Lander[5]->gety()), 
		   $vp->x_viewport($Lander[6]->getx()), 
		   $vp->y_viewport($Lander[6]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[6]->getx()), 
		   $vp->y_viewport($Lander[6]->gety()), 
		   $vp->x_viewport($Lander[7]->getx()), 
		   $vp->y_viewport($Lander[7]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[8]->getx()), 
		   $vp->y_viewport($Lander[8]->gety()), 
		   $vp->x_viewport($Lander[9]->getx()), 
		   $vp->y_viewport($Lander[9]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[5]->getx()), 
		   $vp->y_viewport($Lander[5]->gety()), 
		   $vp->x_viewport($Lander[10]->getx()), 
		   $vp->y_viewport($Lander[10]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[10]->getx()), 
		   $vp->y_viewport($Lander[10]->gety()), 
		   $vp->x_viewport($Lander[11]->getx()), 
		   $vp->y_viewport($Lander[11]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[11]->getx()), 
		   $vp->y_viewport($Lander[11]->gety()), 
		   $vp->x_viewport($Lander[12]->getx()), 
		   $vp->y_viewport($Lander[12]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[12]->getx()), 
		   $vp->y_viewport($Lander[12]->gety()), 
		   $vp->x_viewport($Lander[13]->getx()), 
		   $vp->y_viewport($Lander[13]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[13]->getx()), 
		   $vp->y_viewport($Lander[13]->gety()), 
		   $vp->x_viewport($Lander[14]->getx()), 
		   $vp->y_viewport($Lander[14]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[14]->getx()), 
		   $vp->y_viewport($Lander[14]->gety()), 
		   $vp->x_viewport($Lander[15]->getx()), 
		   $vp->y_viewport($Lander[15]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
    $can->create ( 'line', 
		   $vp->x_viewport($Lander[15]->getx()), 
		   $vp->y_viewport($Lander[15]->gety()), 
		   $vp->x_viewport($Lander[4]->getx()), 
		   $vp->y_viewport($Lander[4]->gety()), 
		   -fill => $fill,
		   -tag  => 'Lander'
		   );
}

### get collision detection bounding box from lander
sub updateClipBox {
    my $smallest_x = $Lander[0]->getx();
    my $smallest_y = $Lander[0]->gety();
    my $largest_x = $Lander[0]->getx();
    my $largest_y = $Lander[0]->gety();
    my $i = 0;

    
    foreach my $v ( @Lander ) {
	# pts 16 and 17 are not really parts of the lander
	# pt 16 is the flame and 17 is center of gravity
	if ( $i < 16 ) {
	    if( $v->getx() <= $smallest_x ) { $smallest_x = $v->getx(); }
	    if( $v->gety() <= $smallest_y ) { $smallest_y = $v->gety(); }
	    if( $v->getx() >= $largest_x ) { $largest_x = $v->getx(); }
	    if( $v->gety() >= $largest_y ) { $largest_y = $v->gety(); }
	}
	$i++;
    }
    $clipbox->setclipboundaries( $smallest_x, $smallest_y, $largest_x, $largest_y);
}
=head1 LunarLander

    A Lunar Lander Video game written in Perl/Tk.

=head1 DESCRIPTION

    A Lunar Lander Video game written in Perl/Tk.

=head1 README

    options:

    -W <canvas width>Default is 500
    -H <canvas height>Default is 500
    -b <background color>Default is blue
    -f <foreground color>Default is yellow
    -F <fuel>Default is 20
    -x <initail x position>Default is 0
    -y <initail y position>Default is 800
    -g <gravity>Default is 1.62 (the moon)
    -a <engine thrust>Default is 20
    -X <initail X velocity> Default is 0
    -Y <initail Y velocity> Default is 0
    -c <crash velocity> Default is 10
    -s <landing slope tolerance> Default is 0
    -S do not resize scene (ship may leave screen)
    -h print this message

    How to play:

    pressing 'k' fires main thruster.
    pressing 'j' rotates lander counter-clockwise
    pressing 'l' rotates lander clockwise
    pressing 'r' restarts the game.

    Place g in m/sec2  
    ----------------
    Moon         1.62
    Mercury         3.58
    Venus         8.87
    Earth9.8
    Mars         3.74
    Jupiter        26.01
    Saturn         11.17
    Uranus         10.49
    Neptune        13.25
    Pluto           0.73

=head1 PREREQUISITES

This script requires the C<strict> module.  
It also requires C<Tk 800.022>.
It also requires C<Tk::Canvas 800.022>.
It also requires C<Math::Trig>.
It also requires C<Vector2D Authur CECALA>
It also requires C<Viewport Author CECALA>
It also requires C<Clip2    Author CECALA>
It also requires C<Getopt::Std>

=head1 COREQUISITES

Tk

=pod OSNAMES

any

=pod SCRIPT CATEGORIES

Fun/Educational
Tk/Example

=cut
