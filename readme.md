# Genome Explorer

[![Build
Status](https://magnum.travis-ci.com/audy/genome-explorer.svg?token=f7yoxymBn6pUMxVADYxk&branch=master)](https://magnum.travis-ci.com/audy/genome-explorer)

[![Code
Climate](https://codeclimate.com/repos/545a939b695680762c0348ba/badges/485a8cdc04eec5267d1b/gpa.svg)](https://codeclimate.com/repos/545a939b695680762c0348ba/feed)

[![Test
Coverage](https://codeclimate.com/repos/545a939b695680762c0348ba/badges/485a8cdc04eec5267d1b/coverage.svg)](https://codeclimate.com/repos/545a939b695680762c0348ba/feed)

(c, 2014) Austin G. Davis-Richardson

LICENSE: MIT

There are those who wish to view genomes (bo-RING!) and then there are those who
wish to _explore_ them.

## Requirements

- Ruby 2.1.2
- Postgres
- The desire to explore the world of bacterial genomes
- A computer

## Quickstart

Using Ruby 2.1.2 and PostgreSQL 9.3

```sh
createdb genome

# with Ruby 2.1.2 and Bundler
bundle install

bundle exec rake db:migrate
bundle exec rackup
```

## Continuous Integration and Deployment

Any push to the `master` branch of this GitHub repository will first be tested
using Travis-CI and then, if tests pass, deployed to genome.austinfanclub.com
via dokku.

## License

The MIT License (MIT)

Copyright (c) 2014 Austin G. Davis-Richardson

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
