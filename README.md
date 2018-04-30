RoleCore
====

RoleCore is a Rails engine which could provide essential industry of Role-based access control.

## Demo

The dummy app shows a simple multiple roles with CanCanCan integration including a management UI.

<img width="550" alt="RoleCore dummy preview" src="https://user-images.githubusercontent.com/5518/37262401-e6c9d604-25dd-11e8-849d-7f7d923d5f18.png">

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

## What's does the RoleCore do

### The role model

The essence of RBAC is the role, despite your application, there are many possibilities: single-role, multi-roles, extendable-role and the role may associate to different kinds of resources (e.g: users and groups)

RoleCore provides a essential definition of Role,
you have to add association to adapt to your application,
for example:

- single-role: adding `one-to-many` association between Role and User
- multi-roles: adding `many-to-many` association between Role and User
- extendable-role: adding a self-association to Role
- polymorphic-asscociated-role: consider using polymorphic association technique

Although it's not out-of-box, but it will give you fully flexibility to suit your needs.

### Permissions definition

RoleCore provides a DSL (which inspired by [Redmine](https://github.com/redmine/redmine/blob/master/lib/redmine.rb#L76-L186)) that allows you define permissions for your application.

Empowered by virtual model technique,
these permissions your defined can be persisted through serialization,
and can be used with OO-style, for example: `role.permissions.project.create?`

There also support permission groups, and groups support nesting.

I18n is supported too.

In fact, the essence of permissions is Hash, keys are permissions, and values are booleans. so computing of permissions with many roles, can be understood as computing of Hashes.

### Management UI

Building a management UI is difficult, 
but virtual model technique will translates permissions to a virtual model's (a class that conforms to ActiveModel) attributes, 
and groups will translates to nested virtual models,
that means you can use all Rails view helpers including the mighty form builder,
and can benefit to Strong Parameter.

The dummy app shows that rendering a permission list [only about 20 lines](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/views/roles/_permissions.html.erb).

If your application is API-only, you can simply dumping the role's permissions to JSON, and can still be benefit to StrongParameter.

### Checking permission

RoleCore **DOES NOT** handle the authentication or authorization directly,
you have to integrate with CanCanCan, Pundit or other solutions by yourself.

RoleCore can be working with CanCanCan, Pundit easily and happily.

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

## Getting start

### Define permissions

Permissions are defined in `config/initializers/role_core.rb`,
checking it to know how to define permissions.

In addition, there also includes a directive about how to integrate with CanCanCan.

#### I18n

Check `config/locales/role_core.en.yml`

### Hook application

In order to obtain maximum customizability, you need to hooking up role(s) to your user model by yourself.

#### User who has single role

##### Create `one-to-many` relationship between Role and User

Generate `one-to-many` migration, adding `role_id` to `User` model

```sh
$ bin/rails g migration AddRoleToUsers role:references
```

Then do migrate

```sh
$ bin/rails db:migrate
```

Declare `a User belongs to a Role` association

```ruby
class User < ApplicationRecord
  belongs_to :role

  # ...
end
```

Declare `a Role has many Users` association

```ruby
class Role < RoleCore::Role
  has_many :users
end
```

##### Checking permission

Permissions you've defined will translate to a virtual model (a Class which implemented ActiveModel interface),
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

#### User who has multiple roles

##### Create `many-to-many` relationship between Role and User

Generate a `many-to-many` intervening model

```sh
$ bin/rails g model RoleAssignment user:references role:references
```

Then do migrate

```sh
$ bin/rails db:migrate
```

Declare `a User has many Roles through RoleAssignments` association

```ruby
class User < ApplicationRecord
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  # ...
end
```

Declare `a Role has many Users through RoleAssignments` association

```ruby
class Role < RoleCore::Role
  has_many :role_assignments, dependent: :destroy
  has_many :users, through: :role_assignments
end
```

##### Check permission

Permissions you've defined will translate to a virtual model (a Class which implemented ActiveModel interface),
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
  delegate :computed_permissions, to: :role
  ```

- For a user who has multiple roles:

  Add a `computed_permissions` public method to User model:

  ```ruby
  def computed_permissions
    roles.map(&:computed_permissions).reduce(RoleCore::ComputedPermissions.new, &:concat)
  end
  ```

Open `app/models/ability.rb`, add `user.computed_permissions.call(self, user)` to `initialize` method.

You can check dummy app for better understanding.

### Management UI

See [RolesController in dummy app](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/controllers/roles_controller.rb)
and relates [view](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/views/roles/_form.html.erb) for details.

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


