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

RoleCore provides an essential definition of Role,
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

**You don't need to any migration when you changing definitions.**

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

### Integrate with Pundit

Just call permissions' method (see `checking permission` above) in Pundit's policy.

e.g:

```ruby
class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    user.permissions.post.update?
  end

  def update_my_own?
    return true if user.permissions.post.update?
    return unless user.permissions.post.update_my_own?
    post.author == user
  end
end
```

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

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    # Apply RoleCole managing permissions
    user.computed_permissions.call(self, user)

    # You still can add other permissions
    can :read_public, :all
  end
end
```

You can check dummy app for better understanding.

### Management UI

See [RolesController in dummy app](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/controllers/roles_controller.rb)
and relates [view](https://github.com/rails-engine/role_core/blob/master/test/dummy/app/views/roles/_form.html.erb) for details.

## Hacking

RoleCore is a Rails engine, and following [the official best practice](http://guides.rubyonrails.org/engines.html#overriding-models-and-controllers), so you can  extend RoleCore by the article suggests.

### Integrate to existing role model

For some reason, you want to use RoleCore's ability and keeping use your own role model, e.g: integrate with [rolify](https://github.com/RolifyCommunity/rolify).

You can archive this goal by:

- Modify the migration file which RoleCore generated, changing the role table name
- Add `include RoleCore::Concerns::Models::Role` to your role model

*Note: If you want another column name or there's no name in your role model, you need to lookup `RoleCore::Concerns::Models::Role` source code, copy and modify to fit your needs*

### Dynamic permissions

By design, RoleCore is for static permissions, but dynamic permissions is easy to support.

The key is `RoleCore::PermissionSet#derive`, that will generate a new anonymous sub-class of `PermissionSet`.

Here's an example:

- Design a model to persisting dynamic permissions, e.g `DynamicPermission(id: bigint, name: string, default: bool)`
- Add `dynamic_permissions` column (`text` type) to Role model to persisting dynamic permissions' configuration, and in your model `serialize :dynamic_permissions, Hash`
- Generate dynamic permissions set in runtime
  ```ruby
  # Create a new permission set to containerize dynamic permissions
  # `"Dynamic"` can be named to other but must be a valid Ruby class name,
  # that's a hacking for `ActiveModel::Naming`,
  # and can be used as I18n key, in this case, the key is `role_core/models/dynamic`.
  dynamic_permission_set_class = PermissionSet.derive "Dynamic"

  # Fetching dynamic permissions
  dynamic_permissions = DynamicPermission.all

  # Mapping dynamic permissions to permission set
  dynamic_permission_set_class.draw do
    dynamic_permissions.each do |p|
      permission p.name, default: p.default
    end
  end
  ```
- Create a instance of this dynamic permission set
  ```ruby
  dynamic_permissions = dynamic_permission_set_class.new(role.dynamic_permissions)
  ```
- You can use the `dynamic_permissions` now

Rails' `serialize` is static so you must do serialize and deserialize manually, you can wrap these logic into model.

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


