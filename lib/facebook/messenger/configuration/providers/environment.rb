module Facebook
  module Messenger
    class Configuration
      module Providers
        # Configuration provider for environment variables.
        class Environment
          def valid_verify_token?(verify_token)
            verify_token == ENV['FB_VERIFY_TOKEN']
          end

          def app_secret_for(*)
            ENV['FB_APP_SECRET']
          end

          def access_token_for(*)
            ENV['FB_ACCESS_TOKEN']
          end
        end
      end
    end
  end
end
