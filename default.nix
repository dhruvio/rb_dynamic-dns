{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "anzsco_crawler";
  buildInputs = [
    ruby_2_4
    stdenv
  ];
  shellHook = ''
    #ensure local gem dir exists
    mkdir -p .gem
    #update env
    export GEM_HOME="$PWD/.gem"
    export GEM_PATH="$GEM_HOME"
    export PATH="$PATH:$GEM_HOME/bin"
    #install bundler
    ${ruby_2_4}/bin/gem install --install-dir $GEM_HOME bundler
    #configure bundler
    export BUNDLE_IGNORE_CONFIG="1"
    export BUNDLE_PATH="vendor/bundle"
    #install depnedencies
    bundle install
  '';
}

