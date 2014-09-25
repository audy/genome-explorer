# Genome Explorer

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
dbcreate genome

# with Ruby 2.1.2 and Bundler
bundle install

export DATABASE_URL=postgres://$USER@127.0.0.1/genome

bundle exec rake db:migrate
bundle exec rackup
```

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
