# frozen_string_literal: true

require 'train/plugins'
require 'oneview-sdk'
require 'uri'

module Train::Transports
  class Oneview < Train.plugin(1)
    name 'oneview'

    # Supply the options or use the INSPEC_ONEVIEW_SETTINGS environment variable, if neither
    # will later default to ~/.oneview/inspec
    option :oneview_settings_file, required: false, default: ENV['INSPEC_ONEVIEW_SETTINGS']
    option :oneview_name, required: false, default: ENV['ONEVIEW_RESOURCE_NAME']
    option :oneview_type, required: false, default: ENV['ONEVIEW_RESOURCE_TYPE']

    def connection(_ = nil)
      @connection ||= Connection.new(@options)
    end

    class Connection < BaseConnection
      def initialize(options)
        super(options)

        # additional Oneview platform metadata
        release = Gem.loaded_specs['oneview-sdk'].version
        @platform_details = { release: "oneview-v#{release}" }

        # Initialize the client object cache
        @cache_enabled[:api_call] = true
        @cache[:api_call] = {}

        connect
      end

      def platform
        direct_platform('oneview', @platform_details)
      end

      # Provide a helper for resource retrieval operations
      def resources(oneview_type = nil, oneview_name = nil)
        oneview_type = @options[:oneview_type] if oneview_type.nil?
        oneview_name = @options[:oneview_name] if oneview_name.nil?
        raise 'Oneview resource type must be specified.' if oneview_type.nil?

        # Determine the endpoint that needs to be called
        endpoint = format('/rest/%s', oneview_type)

        # Find the resources
        response = oneview_client.rest_get(endpoint)
        resources = oneview_client.response_handler(response)

        return resources if oneview_name.nil?

        # Filter the resources by the name if it has been specified
        resources['members'].select { |r| r['name'] == oneview_name }
      end

      # Return the oneview client from the cache if enabled
      def oneview_client
        return OneviewSDK::Client.new(config) unless cache_enabled?(:api_call)
        @cache[:api_call][OneviewSDK::Client.to_s.to_sym] ||= OneviewSDK::Client.new(config)
      end

      def config
        # Use default location
        settings_file = File.join(Dir.home, '.oneview', 'inspec')
        # But supercede wtih the parameter if set
        settings_file = @options[:oneview_settings_file] if @options[:oneview_settings_file]
        # Raise an exception if the file doesn't exist
        raise "Oneview settings file #{settings_file} not found.  Set via ~/.oneview/inspec or INSPEC_ONEVIEW_SETTINGS environment variable." unless File.file?(settings_file)
        # Finally, load the configuration file using the SDK
        OneviewSDK::Config.load(settings_file)
      end

      def connect
        # Set variables if present
        ENV['INSPEC_ONEVIEW_SETTINGS'] = @options[:oneview_settings_file] if @options[:oneview_settings_file]
        ENV['ONEVIEW_RESOURCE_NAME'] = @options[:oneview_name] if @options[:oneview_name]
        ENV['ONEVIEW_RESOURCE_TYPE'] = @options[:oneview_type] if @options[:oneview_type]
      end

      def uri
        "oneview://#{unique_identifier}"
      end

      def unique_identifier
        # use the Oneview config to construct something meaningful
        params = config
        uri = URI.parse(params['url'])
        user = params['user']
        "#{user}@#{uri.host}"
      end
    end
  end
end
