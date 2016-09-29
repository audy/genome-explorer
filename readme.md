# Genome Explorer

[![Build Status](https://travis-ci.org/audy/genome-explorer.svg)](https://travis-ci.org/audy/genome-explorer)
[![Code Climate](https://codeclimate.com/repos/545a939b695680762c0348ba/badges/485a8cdc04eec5267d1b/gpa.svg)](https://codeclimate.com/repos/545a939b695680762c0348ba/feed)
[![Test Coverage](https://codeclimate.com/repos/545a939b695680762c0348ba/badges/485a8cdc04eec5267d1b/coverage.svg)](https://codeclimate.com/repos/545a939b695680762c0348ba/feed)

(c) 2014-2016 Austin G. Davis-Richardson

LICENSE: MIT

There are those who wish to view genomes (bo-RING!) and then there are those who
wish to _explore_ them.

## Requirements

- Ruby 2.1.2
- node.js
- Postgres
- The desire to explore the world of bacterial genomes
- A computer

## Quickstart

Using Ruby 2.1.2 and PostgreSQL 9.3

```sh
# with Ruby 2.1.2 and Bundler
bundle install

bundle exec rake db:setup
bundle exec rackup
```

## Continuous Integration and Deployment

Any push to the `master` branch of this GitHub repository will first be tested
using Travis-CI and then, if tests pass, deployed to genome.austinfanclub.com
via dokku.

## License

The MIT License (MIT)

Copyright (c) 2014-2016 Austin G. Davis-Richardson

See `LICENSE` for details.
