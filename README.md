RoleCore
====

RoleCore is a Rails engine which could provide essential industry of Role-based access control.

<img width="550" alt="2018-03-12 10 12 21" src="https://user-images.githubusercontent.com/5518/37262401-e6c9d604-25dd-11e8-849d-7f7d923d5f18.png">

It's only provides the ability to define permissions and pre-made Role model.

In addition, it's not handle the authentication or authorization,
you should integrate with CanCanCan, Pundit or other solutions by yourself.

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

### Hook up to application

In order to obtain maximum customability, you need to hooking up role(s) to your user model by yourself.

#### For User who has single role

##### Create `one-to-many` relationship between Role and User

Generate `one-to-many` migration, adding `role_id` to `User` model

```sh
$ bin/rails g migration AddRoleToUsers role:references
```

Then do migrate

```sh
$ bin/rails db:migrate
```

Declare `a User belongs to a Role`

```ruby
class User < ApplicationRecord
  belongs_to :role

  # ...
end
```

Declare `a Role has many Users`

```ruby
class Role < RoleCore::Role
  has_many :users
end
```

##### Check permission

Permssions you've defined will translate to a virtual model (a Class which implemented ActiveModel interface),
`permission` would be an attribute, `group` would be a nested virtual model (like ActiveRecord's `has_one` association).

So you can simply check permission like:

```ruby
user.role.permissions.read_public?
user.role.permissions.project.read? # `project` is a `group`
```

For better usage, you may delegate the `permissions` from `Role` model to `User`:

```ruby
class User < ApplicationRecord
  belongs_to :role

  delegate :permissions, to: :role

  # ...
end
```

Then you can

```ruby
user.permissions.read_public?
user.permissions.project.read?
```

_Keep in mind: fetching `role` will made a SQL query, you may need eager loading to avoid N+1 problem in some cases._

#### For User who has multiple roles

##### Create `many-to-many` relationship between Role and User

Generate a `many-to-many` intervening model

```sh
$ bin/rails g model RoleAssignment user:references role:references
```

Then do migrate

```sh
$ bin/rails db:migrate
```

Declare `a User has many Roles through RoleAssignments`

```ruby
class User < ApplicationRecord
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  # ...
end
```

Declare `a Role has many Users through RoleAssignments`

```ruby
class Role < RoleCore::Role
  has_many :role_assignments, dependent: :destroy
  has_many :users, through: :role_assignments
end
```

##### Check permission

Permssions you've defined will translate to a virtual model (a Class which implemented ActiveModel interface),
`permission` would be an attribute, `group` would be a nested virtual model (like ActiveRecord's `has_one` association).

So you can simply check permission like:

```ruby
user.roles.any? { |role| role.permissions.read_public? }
user.roles.any? { |role| role.permissions.project.read? } # `project` is a `group`
```

For better usage, you could declare a `can?` helper method:

```ruby
class User < ApplicationRecord
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  def can?(&block)
    roles.map(&:permissions).any?(&block)
  end

  # ...
end
```

Then you can

```ruby
user.can? { |permissions| permissions.read_public? }
user.can? { |permissions| permissions.project.read? }
```

_Keep in mind: fetching `roles` will made a SQL query, you may need eager loading to avoid N+1 problem in some cases._

### Integrate with CanCanCan

Open `config/initializers/role_core.rb`, uncomment CanCanCan integration codes and follows samples to define permissions for CanCanCan

Open your User model:

- For a user who has single role:

  Add a delegate to User model:

  ```ruby
  delegate :permitted_permissions, to: :role
  ```

- For a user who has multiple roles:

  Add a `permitted_permissions` public method to User model:

  ```ruby
  def permitted_permissions
    roles.map(&:permitted_permissions).reduce(RoleCore::ComputedPermissions.new, &:concat)
  end
  ```

Open `app/models/ability.rb`, add `user.permitted_permissions.call(self, user)` to `initialize` method.

You can check RoleCore's Demo (see below) for better understanding.

### Management UI

See [RolesController in dummy app](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/controllers/roles_controller.rb)
and relates [view](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/views/roles/_form.html.erb).

## Demo

The dummy app shows a simple multiple roles with CanCanCan integration includes management UI.

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
