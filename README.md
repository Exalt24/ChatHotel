# ChatHotel

A hotel booking platform with dynamic day-by-day pricing, real-time reservations, and a full admin panel. Built solo in a three-day sprint during my Full Stack Developer internship at ChatGenie.PH (Techstars '23).

Guests browse hotels, make bookings against live availability, and leave reviews; administrators manage hotels, users, bookings, and per-day price adjustments from a dedicated admin area.

## Features

- **Dynamic pricing** — administrators set day-level price adjustments, so nightly rates vary by date rather than staying flat.
- **Real-time reservations** — booking updates are pushed over Action Cable so availability stays current without a manual refresh.
- **Full authentication** — account registration with email activation, secure sessions, and password reset flows.
- **Reviews** — guests can review hotels they have booked.
- **Admin panel** — manage hotels, users, bookings, and day-price adjustments.

## Tech Stack

- **Framework:** Ruby on Rails (Ruby 3.3.2)
- **Real-time:** Action Cable (WebSockets)
- **Frontend:** Hotwire / Stimulus with an import-map JavaScript setup
- **Deployment:** Docker + Render (`render.yaml` included)
- **CI:** GitHub Actions

## Getting Started

```bash
bundle install          # install Ruby dependencies
rails db:create db:migrate db:seed   # set up the database
rails server            # run at http://localhost:3000
```

Run the test suite with `rails test`.

## Structure

Standard Rails layout. The domain lives in `app/controllers` (bookings, hotels, reviews, sessions, account activation, password resets, and an `admin/` namespace) and `app/models`, with pricing logic in `app/helpers/pricing_helper.rb` and real-time updates in `app/channels`.

## Context

This was built in a compressed three-day internship sprint at ChatGenie.PH, one of two applications I shipped solo during that internship (the other is [ChatDaters](https://github.com/Exalt24/ChatDaters)).
