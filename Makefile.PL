use inc::Module::Install;

name q(CatalystX-Controller-Sugar-ActionPack);
all_from q(lib/CatalystX/Controller/Sugar/ActionPack.pm);

requires q(CatalystX::Controller::Sugar) => 0.05;
requires q(File::Slurp) => 9999.10;
test_requires q(Data::Dumper) => 2.1;
test_requires q(Moose) => 0.94;
test_requires q(Test::More) => 0.94;

bugtracker 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=CatalystX-Controller-Sugar-ActionPack';
homepage 'http://search.cpan.org/dist/CatalystX-Controller-Sugar-ActionPack';
repository 'git://github.com/jhthorsen/catalystx-controller-sugar-actionpack.git';

auto_install;
WriteAll;
