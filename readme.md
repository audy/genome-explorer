# Genome Explorer

[![Build Status](https://travis-ci.org/audy/genome-explorer.svg)](https://travis-ci.org/audy/genome-explorer)

There are those who wish to view genomes (bo-RING!) and then there are those who
wish to _explore_ them.

## Requirements

- Ruby/Rails
- Postgres
- The desire to explore the world of bacterial genomes
- A computer

## Quickstart

```sh
# with Ruby 2.1.2 and Bundler
bundle install

bundle exec rake db:setup
bundle exec rackup
```

## Deployment

Just docker:

```bash
docker pull audy/genome-explorer
```

Using docker-compose:

```bash
docker-compose up
```

### First time deployment

If this is your first time exploring genomes, you'll need to migrate the
database (after running `docker-compose up`):

```bash
docker-compose run --entrypoint rake web db:migrate
```

### Seeding

Seeding in Docker is not currently supported due to the dependency on non-open
source software (sorry about that). If you send me an email, I will send you a
dump of the production postgres database.

## License

The MIT License (MIT)

Copyright (c) 2014-2018 Austin G. Davis-Richardson

See `LICENSE` for details.
