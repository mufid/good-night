
module Goodnight::V202509
  class API < ::Goodnight::ApplicationAPI
    mount Sleeps
    mount Users
    mount UserFollowings

    add_swagger_documentation \
      add_version: true,
      base_path: '/api/2025-09',
      doc_version: '2025-09',
      security_definitions: {
        naive_user_auth: {
          type: "basic",
          description: "You can use User ID for username and lave the Password empty. Password will be ignored.",
        }
      },
      security: [
        { naive_user_auth: [] }
      ],
      info: {
        title: "Goodnight API",
        description: "Swagger UI for Goodnight",
      }
  end
end