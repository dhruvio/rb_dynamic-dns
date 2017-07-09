run:
	bundle exec ruby -I lib bin/dynamic-dns

install:
	bundle install --path vendor/bundle

dependencies:
	@ echo '0. ruby (use your package manager)'
	@ echo '1. bundle (gem install bundle)'
