require_relative 'daemon'

DOMAIN    = ENV['DYNAMIC_DNS_DOMAIN']
SUBDOMAIN = ENV['DYNAMIC_DNS_SUBDOMAIN']
INTERVAL  = ENV['DYNAMIC_DNS_INTERVAL']

daemon = DynamicDns::Daemon.new DOMAIN, SUBDOMAIN, (INTERVAL and Integer INTERVAL)
daemon.start
