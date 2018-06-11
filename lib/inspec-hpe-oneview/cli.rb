# frozen_string_literal: true

require 'inspec/plugins'
require 'thor'
require 'inspec-hpe-oneview/server_hardware'

module Oneview
  class CLI < Thor
    namespace 'oneview'

    desc 'server_hardware', 'Run an InSpec Oneview REST API call to print server-hardware output'
    def server_hardware
      ServerHardware::APICall.print
    end
  end

  Inspec::Plugins::CLI.add_subcommand(CLI, 'oneview', 'server_hardware SUBCOMMAND ...', 'Additional Example commands', {})
end
