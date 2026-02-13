# URL Shortener

## Requirements
- Submit a URL from a form on the homepage.
- Save the URL to the database.
- Expose a Base62-encoded short code for redirects at `/v/:code` (derived from the primary key).
- Allow the user to copy the short URL to the clipboard.
- When visiting the short code:
  - Record a view (with timestamp, referrer, user agent) to track daily views.
  - Increment a `views_count` counter on the URL record.
  - Track unique visitors by IP and increment `unique_views_count`.
- Show a graph of daily views for the past 14 days.
- Show top referrers as a donut chart.
- Show a paginated table of recent clicks (time, referrer, user agent).
- Allow users to edit and delete a URL.
- Retrieve the page metadata (title, description, Open Graph image).
  - This should run in the background to keep the app fast.
  - If the destination URL is edited, refresh the metadata.
- Paginate the list of shortened URLs.
- Password reset via email (Gmail SMTP).

## Tech Stack
- **Backend**: Ruby 3.3, Rails 8.0.2, PostgreSQL 16+
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Server**: Puma
- **Dependencies**: Managed with [Bundler](http://bundler.io/)

## Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `HOST` | Yes (production) | — | Custom domain (e.g. `go.fabianveliz.com`) |
| `SMTP_USERNAME` | Yes (production) | — | Gmail address for sending emails |
| `SMTP_PASSWORD` | Yes (production) | — | Gmail App Password (16-char) |
| `REDIS_URL` | Yes (production) | `redis://localhost:6379/1` | Redis URL for Action Cable |
| `DATABASE_URL` | Yes (production) | — | PostgreSQL connection string |
| `RAILS_LOG_LEVEL` | No | `info` | Log level (`debug`, `info`, `warn`, `error`) |
| `RAILS_MAX_THREADS` | No | `3` | Puma thread count |
| `PORT` | No | `3000` | Server port |
| `WEB_CONCURRENCY` | No | — | Puma worker count |

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

## Architecture Overview
![Class diagram](docs/images/class_diagram.png)

<details>
<summary>View diagram source code</summary>

```mermaid
classDiagram
  class User {
    +id: bigint
    +email: string
    +encrypted_password: string
    +reset_password_token: string
    +reset_password_sent_at: datetime
    +remember_created_at: datetime
    +created_at: datetime
    +updated_at: datetime

    %% Relations / methods
    +links(): ActiveRecord::Relation
  }
  note for User "Devise: database_authenticatable<br/>registerable<br/>recoverable<br/>rememberable<br/>validatable"

  class Link {
    +id: bigint
    +url: string
    +title: string
    +description: string
    +image: string
    +views_count: integer
    +unique_views_count: integer
    +user_id: bigint
    +created_at: datetime
    +updated_at: datetime

    %% Public methods
    +to_param(): string
    +domain(): string
    +has_metadata?(): boolean
    +top_referrers(limit): Hash
    -strip_url(): void

    %% Class methods
    +static find_by_id_param!(id): Link
  }
  note for Link "Scopes: ordered(), by_id_param(id)<br/>Validations: validates :url, presence: true<br/>Callbacks: before_validation :strip_url, after_save_commit<br/>Jobs: MetadataJob.perform_later<br/>Broadcasts: turbo_streams to user"

  class View {
    +id: bigint
    +link_id: bigint
    +user_agent: string
    +ip: string
    +referrer: string
    +created_at: datetime
    +updated_at: datetime

    %% Relations
    +link(): Link
  }
  note for View "belongs_to :link (counter_cache: true)<br/>Scopes: ordered()<br/>Callbacks: after_create :increment_unique_views_if_new_ip"

  class Base62 {
    +static ALPHABET: string
    +static BASE: integer
    +static encode(number): string
    +static decode(string): integer
  }

  class Metadata {
    +doc: Nokogiri::HTML::Document
    +static retrieve_from(url): Metadata
    +initialize(html): void
    +attributes(): Hash
    +title(): string
    +description(): string
    +image(): string
    -content_for(property): string
  }

  User "1" --> "many" Link : has_many
  Link "1" --> "many" View : has_many
  Link "*" --> "1" User : belongs_to
  View "*" --> "1" Link : belongs_to
  Link ..> Base62 : uses
  Link ..> Metadata : uses
```

</details>

## Key Features
- **URL Shortening**: Base62 encoding for compact URLs
- **Metadata Extraction**: Background job fetches title, description, and images
- **Real-time Updates**: Turbo Streams for live UI updates
- **Analytics**: Total views, unique visitors, referrer tracking, daily view graphs
- **Authentication**: Devise with password reset via Gmail SMTP
- **Dark Mode**: System-preference-aware theme switching

## Models
- **User**: Authentication and link ownership
- **Link**: Core URL shortening with metadata and analytics counters
- **View**: Click tracking with referrer, user agent, and IP
- **Base62**: ID encoding utility
- **Metadata**: Web scraping for previews