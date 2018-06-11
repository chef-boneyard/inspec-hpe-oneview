# frozen_string_literal: true

require 'train'

module ServerHardware
  class APICall
    def self.print
      oneview = Train.create('oneview')
      conn = oneview.connection
      puts format('Oneview API version: %s ', conn.oneview_client.api_version)
      puts format('Oneview URI: %s', conn.uri)
      puts '=> API call to server-hardware ...'
      puts conn.resources('server-hardware')
    end
  end
end
