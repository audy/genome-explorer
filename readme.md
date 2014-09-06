# Genome Explorer

## Requirements

- Ruby 2.1.2
- Postgres
- A computer

## Quickstart

Using Ruby 2.1.2 and PostgreSQL 9.3

```sh
dbcreate genome

# with Ruby 2.1.2 and Bundler
bundle install

export DATABASE_URL=postgres://$USER@127.0.0.1/genome

bundle exec rake db:migrate
bundle exec rackup
```
