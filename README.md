# Good Night Application

Record your sleep!

## Running Application

You can run the application by using `docker-compose`:

    docker-compose up

## Architecture

- **Grape:** API is implemented within Grape
- **Rails:** All other components is using standard Rails pattern
- **ActiveModel:** All form submission is processed with ActiveModel
  with Rails' built-in form validation
- **Service Pattern:** on complex operations requiring more than one
  model, service is used.
- **API Versioning:** Use date for API versioning instead of a number
  (Shopify Style).
  - Read more: [Shopify API Versioning](https://shopify.dev/docs/api/usage/versioning)

## Performance Consideration

- **Cursor instead of pagination:** It is well-documented that
  cursor is preferred on large rows instead of pagination. This is
  heavily inspired by Shopify and Stripe.
  - Read more: [On Cursor Performance](https://shopify.engineering/pagination-relative-cursors)