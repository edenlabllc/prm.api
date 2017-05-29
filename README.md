# PRM API

[![Build Status](https://travis-ci.org/Nebo15/prm.api.svg?branch=master)](https://travis-ci.org/Nebo15/prm.api) [![Coverage Status](https://coveralls.io/repos/github/Nebo15/prm.api/badge.svg?branch=master)](https://coveralls.io/github/Nebo15/prm.api?branch=master)

Partnership Relations Management API for Ukrainian Health Services government institution.

## Specification

- [API docs](http://docs.ehealthapi1.apiary.io/#reference/internal.-partner-relationship-management)
- [Entity-relation diagram](https://edenlab.atlassian.net/wiki/display/EH/PRM)

## Installation

You can use official Docker container to deploy this service, it can be found on [nebo15/prm](https://hub.docker.com/r/nebo15/prm/) Docker Hub.

### Dependencies

- PostgreSQL 9.6 is used as storage back-end.
- Elixir 1.4
- Erlang/OTP 19.2

## Configuration

See [ENVIRONMENT.md](docs/ENVIRONMENT.md).

## License

See [LICENSE.md](LICENSE.md).