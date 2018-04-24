RoleCore
====

A Rails engine providing essential industry of Role-based access control.

<img width="550" alt="2018-03-12 10 12 21" src="https://user-images.githubusercontent.com/5518/37262401-e6c9d604-25dd-11e8-849d-7f7d923d5f18.png">

## Installation

Add this line to your Gemfile:

```ruby
gem 'role_core'
```

Then execute:

```sh
$ bundle
```

Copy migrations

```sh
$ bin/rails role_core:install:migrations
```

Then do migrate

```sh
$ bin/rails db:migrate
```

Run config generator

```sh
$ bin/rails g role_core:config
```

Run model generator

```sh
$ bin/rails g role_core:model
```

## Getting Start

### Define permissions

Permissions are defined in `config/initializers/role_core.rb`,
checking it to know how to define permissions.

In addition, there also includes a directive about how to integrate with CanCanCan.

### For a user who has single role

TODO

```sh
$ bin/rails g migration AddRoleToUsers role:references
```

### For a user who has multiple roles

TODO

```sh
$ bin/rails g model RoleAssignment user:references role:references
```

### Integrate with CanCanCan

TODO

## Demo

Clone the repository.

```sh
$ git clone https://github.com/rails-engine/role_core.git
```

Change directory

```sh
$ cd role_core
```

Run bundler

```sh
$ bundle install
```

Preparing database

```sh
$ bin/rails db:migrate
```

Start the Rails server

```sh
$ bin/rails s
```

Open your browser, and visit `http://localhost:3000`

## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
