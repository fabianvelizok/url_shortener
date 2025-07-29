# URL Shortener

## Requirements
- Submit a URL from a form on the homepage.
- Save the URL to the database.
- Expose a Base62-encoded short code for redirects at `/v/:code` (derived from the primary key).
- Allow the user to copy the short URL to the clipboard.
- When visiting the short code:
  - Record a view (with timestamp) to track daily views.
  - Increment a `total_views` counter on the URL record.
- Show a graph of daily views for the past 14 days.
- Allow users to edit and delete a URL.
- Retrieve the page metadata (title, description, Open Graph image).
  - This should run in the background to keep the app fast.
  - If the destination URL is edited, refresh the metadata.
- Paginate the list of shortened URLs.

## Dependencies

Ruby library dependencies are managed with [Bundler](http://bundler.io/) in the `Gemfile`.

- Ruby 3.3
- Rails ~> 8.0.2
- PostgreSQL 16+
- Hotwire (Turbo + Stimulus)
- Tailwind CSS (tailwindcss-rails)
- Puma

## Setup

```bash
bundle install
bin/rails db:prepare
```

## Run

```bash
bin/dev
```

## Test

```bash
bin/rails test
```