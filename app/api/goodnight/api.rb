module Goodnight
  class API < ApplicationAPI
    # Shopify-like API versioning
    mount ::Goodnight::V202509::API => '/2025-09'
  end
end
