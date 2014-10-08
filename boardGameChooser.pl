#!/usr/bin/env perl
# boardGameChooser.pl by Amory Meltzer
# Choose a board game to play
# http://cdn4.nerdapproved.com/wp-content/uploads/2013/12/choose-the-perfect-board-game.jpg

use strict;
use warnings;
use diagnostics;

sub choose
{
    my $result = 3;
    until ($result =~ /^y(es)?$/i || $result =~ /^no?$/i)
    {
	print @_;
	print "\n[Y]es or [N]o?\n";
	$result = <>;
    }
    return 1 if $result =~ /^y(es)?$/i;
    return 2 if $result =~ /^no?$/i;
}


my $children = choose("Are you playing with children?");
if ($children == 1)
{
    my $younger = choose("Younger than 7?");
    if ($younger == 1)
    {
	my $girls = choose("Girly girls only?");
	if ($girls == 1)
	{
	    print "Candy Land\n";
	}
	if ($girls == 2)
	{
	    my $real = choose("Real rules or just for fun?");
	    if ($real == 1)
	    {
		my $rules = choose("Actually fun for adults?");
		if ($rules == 1)
		{
		    print "Sorry!\n";
		}
		if ($rules == 2)
		{
		    print "Life\n";
		}
	    }
	    if ($real == 2)
	    {
		my $rube = choose("Rube Goldberg?");
		if ($rube == 1)
		{
		    print "Mouse Trap\n";
		}
		if ($rube == 2)
		{
		    print "Operation\n";
		}
	    }
	}
    }
    if ($younger == 2)
    {
	my $defeat = choose("Let them experience crushing defeat?");
	if ($defeat == 1)
	{
	    print "Monopoly\n";
	}
	if ($defeat == 2)
	{
	    my $portable = choose("Portable?");
		if ($portable == 1)
		{
		    print "Yahtzee!\n";
		}
		if ($portable == 2)
		{
		    my $winner = choose("One winner or a team effort?");
		    if ($winner == 1)
		    {
			print "Forbidden Island\n";
		    }
		    if ($winner == 2)
		    {
			print "Small World\n";
		    }
		}
	}
    }
}
if ($children == 2)
{
    my $two = choose("Play for more than two hours?");
    if ($two == 1)
    {
	my $hardest = choose("Hardest rules ever?");
	if ($hardest == 1)
	{
	    print "Axis and Allies\n";
	}
	if ($hardest == 2)
	{
	    my $players = choose("All players in until the end?");
	    if ($players == 1)
	    {
		print "Le Havre\n";
	    }
	    if ($players == 2)
	    {
		my $dice = choose("Dice battles or 100% strategy?");
		if ($dice == 1)
		{
		    print "Game of Thrones\n";
		}
		if ($dice == 2)
		{
		    print "Risk\n";
		}
	    }
	}
    }
    if ($two == 2)
    {
	my $nerd = choose("Are you a huge nerd?");
	if ($nerd == 1)
	{
	    my $dozens = choose("Do you want to spend dozens of hours preparing to play?");
	    if ($dozens == 1)
	    {
		print "Warhammer\n";
	    }
	    if ($dozens == 2)
	    {
		my $money = choose("Do you really like spending money?");
		if ($money == 1)
		{
		    print "Magic\n";
		}
		if ($money == 2)
		{
		    my $boomer = choose("Does the name Boomer give you wet dreams?");
		    if ($boomer == 1)
		    {
			print "Battlestar Galactica\n";
		    }
		    if ($boomer == 2)
		    {
			print "Cosmic Encounter\n";
		    }
		}
	    }
	}
	if ($nerd == 2)
	{
	    my $along = choose("Do you think everyone should just get along?");
	    if ($along == 1)
	    {
		my $dick = choose("Do you secretly wish you were a dick (a P.I.)?");
		if ($dick == 1)
		{
		    print "Arkham Horror\n";
		}
		if ($dick == 2)
		{
		    my $monty = choose("Do you have a Monty Python fetish?");
		    if ($monty == 1)
		    {
			print "Shadows Over Camelot\n";
		    }
		    if ($monty == 2)
		    {
			my $zombies = choose("Zombies?");
			if ($zombies == 1)
			{
			    print "Last Night on Earth\n";
			}
			if ($zombies == 2)
			{
			    my $virus = choose("WOuld you rather fight monsters or viruses?");
			    if ($virus == 1)
			    {
				print "Pandemic\n";
			    }
			    if ($virus == 2)
			    {
				print "Dungeon Run\n";
			    }
			}
		    }
		}
	    }
	    if ($along == 2)
	    {
		my $gamble = choose("Do you like to gamble?");
		if ($gamble == 1)
		{
		    print "Rummoli\n";
		}
		if ($gamble == 2)
		{
		    my $fifty = choose("Are you over 50 years old?");
		    if ($fifty == 1)
		    {
			my $manyold = choose("More than two of you?");
			if ($manyold == 1)
			{
			    print "Cribbage\n";
			}
			if ($manyold == 2)
			{
			    my $mensa = choose("Are you in Mensa?");
			    if ($mensa == 1)
			    {
				my $chess = choose("Chess too cliche?");
				if ($chess == 1)
				{
				    print "Go\n";
				}
				if ($chess == 2)
				{
				    print "Chess\n";
				}
			    }
			    if ($mensa == 2)
			    {
				print "Backgammon\n";
			    }
			}
		    }
		    if ($fifty == 2)
		    {
			my $party = choose("Party game?");
			if ($party == 1)
			{
			    my $laid = choose("Looking to get laid?");
			    if ($laid == 1)
			    {
				print "Twister\n";
			    }
			    if ($laid == 2)
			    {
				my $embarass = choose("Want to embarass your friends?");
				if ($embarass == 1)
				{
				    my $thug = choose("Do you want to be a thug or an artist?");
				    if ($thug == 1)
				    {
					print "Ca\$h\'N\'Gun\$\n";
				    }
				    if ($thug == 2)
				    {
					print "Cranium\n";
				    }
				}
				if ($embarass == 2)
				{
				    my $liar = choose("Are you a creative liar?");
				    if ($liar == 1)
				    {
					my $trivia = choose("Words or trivia?");
					if ($trivia == 1)
					{
					    print "Beyond Balderdash\n";
					}
					if ($trivia == 2)
					{
					    print "Wits and Wagers\n";
					}
				    }
				    if ($liar == 2)
				    {
					my $hands = choose("Good with your hands?");
					if ($hands == 1)
					{
					    print "Jenga (DK Edition)\n";
					}
					if ($hands == 2)
					{
					    print "Taboo\n";
					}
				    }
				}
			    }
			}
			if ($party == 2)
			{
			    my $know = choose("Are you a know it all?");
			    if ($know == 1)
			    {
				print "Trivial Pursuit\n";
			    }
			    if ($know == 2)
			    {
				my $grades = choose("Get straight As?");
				if ($grades == 1)
				{
				    print "Scrabble\n";
				}
				if ($grades == 2)
				{
				    my $train = choose("Do you have a train fetish?");
				    if ($train == 1)
				    {
					my $econ = choose("Do you enjoy economics?");
					if ($econ == 1)
					{
					    print "Steam\n";
					}
					if ($econ == 2)
					{
					    print "Ticket to Ride\n";
					}
				    }
				    if ($train == 2)
				    {
					my $simple = choose("Simple rules?");
					if ($simple == 1)
					{
					    my $tiles = choose("Tiles or Words?");
					    if ($tiles == 1)
					    {
						print "Qwirkle\n";
					    }
					    if ($tiles == 2)
					    {
						print "Scattergories\n";
					    }
					}
					if ($simple == 2)
					{
					    my $hard = choose("Constant hard choices?");
					    if ($hard == 1)
					    {
						my $farming = choose("Farming fetish?");
						if ($farming == 1)
						{
						    print "Agricola\n";
						}
						if ($farming == 2)
						{
						    my $buy = choose("Do you mind having to buy two games?");
						    if ($buy == 1)
						    {
							my $geek = choose("Are all players serious board game geeks?");
							if ($geek == 1)
							{
							    print "Puerto Rico\n";
							}
							if ($geek == 2)
							{
							    print "Domaine\n";
							}
						    }
						    if ($buy == 2)
						    {
							print "Cities and Knights\n";
						    }
						}
					    }
					    if ($hard == 2)
					    {
						my $card = choose("Card/deck based game?");
						if ($card == 1)
						{
						    my $complexity = choose("Complexity?");
						    if ($complexity == 1)
						    {
							print "7 Wonders\n";
						    }
						    if ($complexity == 2)
						    {
							print "Dominion\n";
						    }
						}
						if ($card == 2)
						{
						    my $plan = choose("Do you like to plan your strategy before your turn?");
						    if ($plan == 1)
						    {
							print "Settlers of Catan\n";
						    }
						    if ($plan == 2)
						    {
							my $defined = choose("Defined turns or no down-time?");
							if ($defined == 1)
							{
							    print "Carcassone\n";
							}
							if ($defined == 2)
							{
							    print "Pillars of the Earth\n";
							}
						    }
						}
					    }
					}
				    }
				}
			    }
			}
		    }
		}
	    }
	}
    }
}
