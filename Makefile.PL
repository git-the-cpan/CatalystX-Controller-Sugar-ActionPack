use inc::Module::Install;

name     q(CatalystX-Controller-Sugar-ActionPack);
all_from q(lib/CatalystX/Controller/Sugar/ActionPack.pm);

requires q(Moose) => 0.80;
requires q(File::Slurp) => 9999.10;
requires q(CatalystX::Controller::Sugar) => 0.04;

test_requires q(Catalyst::Runtime) => 5.80013;
test_requires q(File::Find) => 1.10;
test_requires q(Test::More) => 0.94;

auto_install;
WriteAll;
