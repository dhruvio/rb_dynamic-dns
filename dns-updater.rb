require 'aws-sdk'
require 'json'

module DynamicDns

  class DnsUpdater

    def initialize(domain, subdomain = nil)
      log 'created instance'
      # error handling
      domain.is_a? String or raise RuntimeError, "Invalid domain, must be a String: #{domain}"
      subdomain and subdomain.is_a? String or raise RuntimeError, "Invalid subdomain, must be nil or a String: #{subdomain}"
      # set up constants
      @DOMAIN = domain
      @NAME = create_name(@DOMAIN, subdomain)
      @RECORD_TYPE = 'A'
      @CLIENT = Aws::Route53::Client.new(region: 'us-east-1')
      # fetch the available hosted zones
      log('fetch hosted zones')
      zones = @CLIENT.list_hosted_zones_by_name
      zones = zones.hosted_zones
      # search for the hosted zone matching the configured domain
      log("match hosted zone for domain: #{@DOMAIN}")
      @ZONE = zones.bsearch { |z| z.name.match?("^#{@DOMAIN}") }
      @ZONE or raise RuntimeError, "No hosted zones match #{@DOMAIN}"
    end

    # accessor methods
    attr_reader :DOMAIN
    attr_reader :NAME

    def create_name(domain, subdomain)
      if subdomain
        "#{subdomain}.#{domain}"
      else
        domain
      end
    end

    def update_record_ip(ip, ttl = 60)
      log "update #{@RECORD_TYPE} record for #{@NAME} to point to #{ip}"
      resp = @CLIENT.change_resource_record_sets({
        change_batch: {
          changes: [
            {
              action: 'UPSERT',
              resource_record_set: {
                name: @NAME,
                resource_records: [
                  {
                    value: ip
                  }
                ],
                type: @RECORD_TYPE,
                ttl: ttl 
              }
            }
          ],
          comment: 'Update from dynamic dns ruby script'
        },
        hosted_zone_id: @ZONE.id
      })
      resp = resp.change_info
      log "update of id #{resp.id} is #{resp.status} at #{resp.submitted_at}"
    end

    # prefixed log function
    def log(msg)
      puts "[dynamic-dns:dns-updater] #{msg}"
    end

  end

end
