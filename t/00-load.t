#!/usr/bin/perl
use lib qw(lib);
use Test::More;
plan tests => 5;
use_ok('CatalystX::Controller::Sugar::ActionPack');
use_ok('CatalystX::Controller::Sugar::ActionPack::Default');
use_ok('CatalystX::Controller::Sugar::ActionPack::End');
use_ok('CatalystX::Controller::Sugar::ActionPack::Error');
use_ok('CatalystX::Controller::Sugar::ActionPack::Merge');
