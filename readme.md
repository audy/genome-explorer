# Genome Explorer

- Thin
- PostgreSQL + DataMapper
- RSpec
- Bootstrap + HAML + AssetPack

## Quickstart

Using Ruby 2.1.2 and PostgreSQL 9.3

```
dbcreate genome

bundle install

DATABASE_URL=postgres://$USER@127.0.0.1/genome

bundle exec rake db:migrate
bundle exec rackup
```
