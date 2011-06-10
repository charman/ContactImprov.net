#!/usr/bin/ruby

require 'net/http'

hostname = (ARGV[0] ? ARGV[0]      : 'localhost')
port     = (ARGV[1] ? ARGV[1].to_i : 3000)

print "hostname = #{hostname}\n"
print "port     = #{port}\n\n"


paths = [
  '/',
  '/events',
  '/events/list',
  '/jams',
  '/jams/list',
  '/people',
  '/people/list',
  '/organizations',
  '/organizations/list',
  '/map/feed/combined.xml'
]

paths.each do |path|
  before_cold = Time.now
  Net::HTTP.get hostname, path, port
  dt_cold = Time.now - before_cold
  print "COLD: %.3f - #{path}\n" % dt_cold

  before_warm = Time.now
  Net::HTTP.get hostname, path, port
  dt_warm = Time.now - before_warm
  print "WARM: %.3f - #{path}\n\n" % dt_warm
end
