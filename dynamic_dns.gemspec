Gem::Specification.new do |gem|
  gem.name                   = 'dynamic_dns'
  gem.version                = '0.0.0'
  gem.date                   = '2017-07-09'
  gem.summary                = 'Dynamic DNS'
  gem.description            = 'Daemon to update an Amazon Route53 A record with a computer\'s dynamic IPv4 address.'
  gem.author                 = 'Dhruv Dang'
  gem.email                  = 'hi@dhruv.io'
  gem.executables            = `git ls-files -- bin/*`.split("\n").map { |f| File.basename f }
  gem.files                  = `git ls-files`.split("\n")
  gem.require_paths          = [ 'lib' ]
  gem.license                = 'MIT'
  gem.homepage               = 'https://github.com/dhruvio/rb_dynamic-dns'
  gem.required_ruby_version  = '>=2.4'

  gem.add_runtime_dependency 'aws-sdk', '~> 2.10', '>= 2.10.9'
end
