require "net/http"
require "json"

module Klaviyo
  class SubscribeProfile
    API_URL = "https://a.klaviyo.com/api/profile-subscription-bulk-create-jobs/"

    # Check developers.klaviyo.com for the current revision date before
    # shipping — this is the version of the API this code was written
    # against, not necessarily what's current when you read this.
    API_REVISION = "2026-01-15"

    LIST_IDS = {
      "client"       => Rails.application.credentials.dig(:klaviyo, :client_list_id),
      "professional" => Rails.application.credentials.dig(:klaviyo, :professional_list_id)
    }.freeze

    Result = Struct.new(:success?, :error)

    def self.call(email:, role:)
      new(email: email, role: role).call
    end

    def initialize(email:, role:)
      @email = email
      @role = role
    end

    def call
      uri = URI(API_URL)

      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Klaviyo-API-Key #{private_api_key}"
      request["Content-Type"] = "application/json"
      request["revision"] = API_REVISION
      request.body = request_body.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      if response.code.to_i.between?(200, 299)
        Result.new(true, nil)
      else
        Rails.logger.error("[Klaviyo] Subscribe failed (#{response.code}): #{response.body}")
        Result.new(false, response.body)
      end
    rescue StandardError => e
      Rails.logger.error("[Klaviyo] Subscribe raised: #{e.class} #{e.message}")
      Result.new(false, e.message)
    end

    private

    def private_api_key
      Rails.application.credentials.dig(:klaviyo, :private_api_key)
    end

    def list_id
      LIST_IDS.fetch(@role)
    end

    def request_body
      {
        data: {
          type: "profile-subscription-bulk-create-job",
          attributes: {
            profiles: {
              data: [
                {
                  type: "profile",
                  attributes: {
                    email: @email,
                    subscriptions: {
                      email: {
                        marketing: { consent: "SUBSCRIBED" }
                      }
                    }
                  }
                }
              ]
            }
          },
          relationships: {
            list: {
              data: { type: "list", id: list_id }
            }
          }
        }
      }
    end
  end
end
