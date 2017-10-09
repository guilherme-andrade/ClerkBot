require 'facebook/messenger/version.rb'
require 'facebook/messenger/error.rb'
require 'facebook/messenger/subscriptions.rb'
require 'facebook/messenger/profile.rb'
require 'facebook/messenger/bot.rb'
require 'facebook/messenger/server.rb'
require 'facebook/messenger/configuration.rb'
require 'facebook/messenger/incoming.rb'

module Facebook
  # All the code for this gem resides in this module.
  module Messenger
    def self.configure
      yield config
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.config=(config)
      @config = config
    end

    configure do |config|
      config.provider = Configuration::Providers::Environment.new
    end
  end
end
