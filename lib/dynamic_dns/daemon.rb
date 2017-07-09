require 'net/http'
require 'aws-sdk'
require 'dynamic_dns/dns_updater'

module DynamicDns

  class Daemon

    # create URI to fetch IP address with
    @@GET_IP_URI = URI('https://ipinfo.io/ip')

    def initialize(domain, subdomain, interval)
      log 'created instance'
      # initialize ip address
      @ip = 'NO_IP_SET'
      # initialize the daemon IP interval if necessary
      interval.is_a? Integer or interval = 60
      @INTERVAL = interval
      # set up the dns updater instance
      @UPDATER = DynamicDns::DnsUpdater.new domain, subdomain
    end

    # accessor methods
    attr_reader :ip
    attr_reader :INTERVAL

    # helper to fetch the IP address
    # returns a string represents the ip address
    def fetch_ip
      log 'fetching ip'
      Net::HTTP.get(@@GET_IP_URI)
    end

    def start
      log "starting daemon, will check for new ip every #@INTERVAL seconds"
      # set up the thread to loop
      thread = Thread.new do
        log 'set up thread'
        loop do
          log 'start thread loop iteration'
          # get the ip address
          # if it has changed, update DNS
          new_ip = fetch_ip 
          if new_ip != @ip
            on_new_ip(new_ip)
          else
            log "ip has not changed from #@ip"
          end
          # sleep the number of seconds in the interval
          sleep @INTERVAL
        end
      end  

      # ensure thread exits on an exception
      thread.abort_on_exception = true

      # trap SIGINT to exit threads
      trap 'SIGINT' do
        log "received SIGINT, killing thread"
        thread.kill
      end

      # keep main thread attached while background thread runs
      thread.join
    end

    def on_new_ip(new_ip)
      log "ip has changed from #@ip to #{new_ip}"
      #persist new ip to instance
      @ip = new_ip
      #notify aws
      log "update DNS with new IP #@ip"
      # interval corresponds to ttl in seconds
      @UPDATER.update_record_ip @ip, @INTERVAL
    end

    def log(msg)
      puts "[dynamic-dns:daemon] #{msg}"
    end

  end

end
