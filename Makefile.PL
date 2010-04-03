use inc::Module::Install;
name q(CatalystX-Controller-Sugar-ActionPack);
all_from q(lib/CatalystX/Controller/Sugar/ActionPack.pm);
requires q(CatalystX::Controller::Sugar) => 0.07;
requires q(File::Slurp) => 9999.10;
test_requires q(Catalyst::Runtime) => 5.80021;
test_requires q(Test::More) => 0.9;
auto_insall;
WriteAll;
