# DynamicDNS

DynamicDNS is tool that queries your public IPv4 address periodically, and updates a specific `A` record in Amazon Route53 if this IP address changes.

This gem is useful as a command-line executable, and as a library.


## Usage

The following usage examples will configure the daemon to run every 10 minutes, updating the hosted zone for `foo.com` in Route53 to have an `A` record that points `ssh.foo.com` to the computer's public IPv4 address. See the *Configuration* section below for more information on the environment variables used to configure the daemon.

Ensure you have installed this gem to use the command-line tool. You must have Ruby 2.4, or greater, installed.

```bash
$ gem install dynamic_dns
```


### Command-line

```bash
# use environment variables to configure the daemon
# exit with Ctrl+c
$ DYNAMIC_DNS_DOMAIN=foo.com DYNAMIC_DNS_SUBDOMAIN=ssh DYNAMIC_DNS_INTERVAL=600 dynamic-dns
```


### `systemd` Start-up Script

If you are using `rvm` with `systemd`, ensure that `rvm` was installed using `sudo`, then install this gem.

```ini
[Unit]
Description=DynamicDNS daemon

[Service]
Type=simple
Environment="GEM_HOME=/usr/local/rvm/gems/ruby-2.4.1"
Environment="GEM_PATH=/usr/local/rvm/gems/ruby-2.4.1:/usr/local/rvm/gems/ruby-2.4.1@global"
Environment="PATH=/usr/local/rvm/gems/ruby-2.4.1/bin:/usr/local/rvm/gems/ruby-2.4.1@global/bin:/usr/local/rvm/rubies/ruby-2.4.1/bin:$PATH"
Environment="AWS_ACCESS_KEY_ID=[REDACTED]"
Environment="AWS_SECRET_ACCESS_KEY=[REDACTED]"
Environment="DYNAMIC_DNS_DOMAIN=foo.com"
Environment="DYNAMIC_DNS_SUBDOMAIN=ssh"
Environment="DYNAMIC_DNS_INTERVAL=600"
ExecStart=/usr/local/rvm/gems/ruby-2.4.1/bin/dynamic-dns

[Install]
WantedBy=multi-user.target
```


### Ruby

```ruby
require 'dynamic-dns'

daemon = DynamicDns::Daemon.new "foo.com", "ssh", 600
daemon.start # runs the daemon and blocks the thread
```


## Confirguation

It is possible to configure this daemon using environment variables.

| Variable | Required? | Default | Example | Description |
|:---|:---|:---|:---|:---|
| `DYNAMIC_DNS_DOMAIN` | Y | N/A | `foo.com` | This domain's hosted zone will be updated. It must already have an existing hosted zone in Route53 prior to running the daemon. |
| `DYNAMIC_DNS_SUBDOMAIN` | Y | N/A | `ssh` | The name of the A record that will point to the public IP address discovered by the daemon. |
| `DYNAMIC_DNS_INTERVAL` | N | `60` | `60` | The interval in seconds that the daemon should query for the public IPv4 address. |
| `AWS_ACCESS_KEY_ID` | Y | N/A | `abc123` | Your AWS access key ID. It must have permissions to manage Route53. This requirement is defined by the `aws-sdk` gem ([link](https://github.com/aws/aws-sdk-ruby)). An alternative method to providnig your AWS credentials is to create an `~/.aws/credentials` file. |
| `AWS_SECRET_ACCESS_KEY` | Y | N/A | `abc123` | Your AWS secret access key. See above for notes on AWS credentials. |


## Author

Dhruv Dang  
[hi@dhruv.io](mailto:hi@dhruv.io)  
[dhruv.io](https://dhruv.io)
