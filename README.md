# Good Night Application

Record your sleep!

## Running Application

You can run the application by using `docker-compose`. First, setup the application:

    docker-compose build
    docker-compose run web bin/rails db:create
    docker-compose run web bin/rails db:migrate
    docker-compose run web bin/rails db:seed

Above commands are one-time only. It is not required if it has been ran before. After everything is ready,
run the application:

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

## Endpoints

Swagger UI is available at `http://localhost:3000/swagger`. The endpoints require basic auth with scheme of username of
user id, and blank password. Here are some core endpoints:

- `/api/2025-09/users/timeline`: The main requirement to show the timeline of followed users by current user
- `/api/2025-09/users/clock_in`: To clock in the sleep of current logged-in user. Returning current sleep session object.
- `/api/2025-09/users/:sleep_id/clock_out`: To clock out a sleep.
- `/api/2025-09/users/:user_id_to_follow/follow`: To follow a user.
- `/api/2025-09/users/:user_id_to_unfollow/unfollow`: To unfollow a user.

A random data dumps are created after `bin/rails db:seed`

## Performance Consideration and Strategies

- **Cursor instead of pagination:** It is well-documented that
  cursor is preferred on large rows instead of pagination. This is
  heavily inspired by Shopify and Stripe.
  - Read more: [On Cursor Performance](https://shopify.engineering/pagination-relative-cursors)
- **Avoiding COUNT:** We avoid any count operation as it is expensive and slow.
  - Read more: [Kaminari is slow with COUNT](https://stackoverflow.com/questions/21839330/kaminari-is-slow-with-count-on-a-huge-table-in-postgres)
- **Limit by default:** By default, we only serves 50 entries of data. Client should use cursor to navigate
  more data.
- **Main "Timeline" functionality:** It is segmented by year-week. It requires date as parameter. This way,
  the user can see current week (and practically, any week) of the timeline, as the performance is very fast.

## Performance and Scalability: "Timeline"

    EXPLAIN (ANALYZE, VERBOSE) SELECT "sleeps".* FROM "sleeps" WHERE (duration_minutes > 0) AND (user_id IN (SELECT user_following_id FROM user_followings WHERE user_id=1)) AND "sleeps"."year" = 2025 AND "sleeps"."week" = 36 AND ((duration_minutes = 1923 AND id < 499957) OR (duration_minutes < 1923)) ORDER BY duration_minutes desc, id desc LIMIT 50 /*application='Goodnight'*/
                                                                                                                   QUERY PLAN
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=62722.70..62761.38 rows=50 width=60) (actual time=46.190..48.491 rows=50 loops=1)
       Output: sleeps.id, sleeps.user_id, sleeps.clocked_in_at, sleeps.clocked_out_at, sleeps.duration_minutes, sleeps.created_at, sleeps.updated_at, sleeps.year, sleeps.week
       ->  Nested Loop  (cost=62722.70..544818.04 rows=623192 width=60) (actual time=46.189..48.489 rows=50 loops=1)
             Output: sleeps.id, sleeps.user_id, sleeps.clocked_in_at, sleeps.clocked_out_at, sleeps.duration_minutes, sleeps.created_at, sleeps.updated_at, sleeps.year, sleeps.week
             Inner Unique: true
             ->  Gather Merge  (cost=62722.28..261343.61 rows=623192 width=60) (actual time=46.174..48.448 rows=50 loops=1)
                   Output: sleeps.id, sleeps.user_id, sleeps.clocked_in_at, sleeps.clocked_out_at, sleeps.duration_minutes, sleeps.created_at, sleeps.updated_at, sleeps.year, sleeps.week
                   Workers Planned: 2
                   Workers Launched: 2
                   ->  Incremental Sort  (cost=61722.26..188411.77 rows=259663 width=60) (actual time=44.234..44.265 rows=513 loops=3)
                         Output: sleeps.id, sleeps.user_id, sleeps.clocked_in_at, sleeps.clocked_out_at, sleeps.duration_minutes, sleeps.created_at, sleeps.updated_at, sleeps.year, sleeps.week
                         Sort Key: sleeps.duration_minutes DESC, sleeps.id DESC
                         Presorted Key: sleeps.duration_minutes
                         Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 30kB  Peak Memory: 30kB
                         Pre-sorted Groups: 1  Sort Method: external merge  Average Disk: 12784kB  Peak Disk: 12784kB
                         Worker 0:  actual time=43.475..43.520 rows=745 loops=1
                           Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 30kB  Peak Memory: 30kB
                           Pre-sorted Groups: 1  Sort Method: external merge  Average Disk: 11848kB  Peak Disk: 11848kB
                         Worker 1:  actual time=43.197..43.241 rows=745 loops=1
                           Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 30kB  Peak Memory: 30kB
                           Pre-sorted Groups: 1  Sort Method: external merge  Average Disk: 11672kB  Peak Disk: 11672kB
                         ->  Parallel Index Scan Backward using index_sleeps_on_year_and_week_and_duration_minutes_and_user_id on public.sleeps  (cost=0.42..154106.84 rows=259663 width=60) (actual time=0.030..24.768 rows=166652 loops=3)
                               Output: sleeps.id, sleeps.user_id, sleeps.clocked_in_at, sleeps.clocked_out_at, sleeps.duration_minutes, sleeps.created_at, sleeps.updated_at, sleeps.year, sleeps.week
                               Index Cond: ((sleeps.year = 2025) AND (sleeps.week = 36) AND (sleeps.duration_minutes > 0))
                               Filter: (((sleeps.duration_minutes = 1923) AND (sleeps.id < 499957)) OR (sleeps.duration_minutes < 1923))
                               Rows Removed by Filter: 17
                               Worker 0:  actual time=0.052..24.568 rows=163181 loops=1
                               Worker 1:  actual time=0.021..24.890 rows=160706 loops=1
             ->  Index Only Scan using index_user_followings_on_user_id_and_user_following_id on public.user_followings  (cost=0.42..0.45 rows=1 width=8) (actual time=0.001..0.001 rows=1 loops=50)
                   Output: user_followings.user_id, user_followings.user_following_id
                   Index Cond: ((user_followings.user_id = 1) AND (user_followings.user_following_id = sleeps.user_id))
                   Heap Fetches: 0
     Planning Time: 0.261 ms
     Execution Time: 48.999 ms

As we can see, the timeline search is very fast as it is using index scan already.

## Performance and Scalability: "Cursor"

On any endpoint that results a list, you may use `after` parameter for fetching next page. For example:

    $ curl -X 'GET' \
      'http://localhost:3000/api/2025-09/users/timeline' \
      -H 'accept: application/json' \
      -H 'authorization: Basic MTp1bmRlZmluZWQ='

    Response:
    {
      "data": [ ... ]
      "has_more": true,
      "next_timestamp": "499957-1923"
    }

`has_more` field indicates if there is data available on the next "page". To retrieve the next page,
use `after=499957-1923`

    $ curl -X 'GET' \
      'http://localhost:3000/api/2025-09/users/timeline?after=499957-1923' \
      -H 'accept: application/json' \
      -H 'authorization: Basic MTp1bmRlZmluZWQ='


