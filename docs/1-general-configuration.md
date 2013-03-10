# General Configuration

* application-wide settigns go in `config/initializers/active_admin.rb`
* resource-specific settings go in `app/admin/*.rb`

## Authentication

By default we authenticate AdminUser model using [Devise](https://github.com/plataformatec/devise):

```ruby
# config/initializers/active_admin.rb
config.authentication_method = :authenticate_admin_user! # method called on controller to require login
config.current_user_method   = :current_admin_user       # helper method to access the current user logged in
```

To change the model used for authentication (e.g., the User model):

```ruby
config.authentication_method = :authenticate_user!
config.current_user_method   = :current_user
````

To turn off authentication:

```ruby
config.authentication_method = false
config.current_user_method   = false
```

## Site Title Options

You can easily configure the sitle title. By default there is no link and the title is set to your application name.

```ruby
# config/initializers/active_admin.rb
config.site_title       = "My Admin Site"      # The string displayed
config.site_title_link  = "/"                  # Where you want it to link to (if anywhere)
config.site_title_image = "site_log_image.png" # An image you want displayed (should be in the /public folder)
```

## Internationalization (I18n)

Active Admin comes with built-in translations, but you can easily customize them by providing your own in your
`config/locales` directory. Check out the [English locale file](/lib/active_admin/locales/en.yml)
to see what can be translated.

## Namespaces

When registering resources in Active Admin, they are loaded into a namespace.
The default namespace is "admin".

```ruby
# app/admin/posts.rb
ActiveAdmin.register Post do
  # ...
end
```

The Post resource will be loaded into the "admin" namespace and will be
available at `/admin/posts`. Each namespace holds on to its own configuration
settings which inherit from the application's general configurations.

For example, if you have two namespaces: `:admin` and `super_admin` and want to
have different site title's for each namespace. You can use the
`config.namespace(name)` block within the initializer file to configure them
individually.

```ruby
ActiveAdmin.setup do |config|
  config.site_title = "My Default Site Title"

  config.namespace :admin do |admin|
    admin.site_title = "Admin Site"
  end

  config.namespace :super_admin do |super_admin|
    super_admin.site_title = "Super Admin Site"
  end
end
```

Each setting available in the Active Admin setup block is configurable on a per
namespace basis.

## Load paths

By default Active Admin files go under `/app/admin`. You can change this
directory in the initializer file:

```ruby
ActiveAdmin.setup do |config|
  config.load_paths = [File.join(Rails.root, "app", "ui")]
end
```

## Comments

By default Active Admin includes comments on resources. Sometimes, this is
undesired. To disable comments for the entire application:

```ruby
ActiveAdmin.setup do |config|
  config.allow_comments = false
end
```

If you would like to enable / disable comments for just a namespace, do the
following:

```ruby
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.allow_comments = false
  end
end
```

You can also disable comments for a specific resource:

```ruby
ActiveAdmin.register Post do
  config.comments = false
end
```

## Utility Navigation

The "utility navigation" shown at the top right when logged in by default shows the current
user email address and a link to "Log Out".  However, the utility navigation is just like
any other menu in the system, so you can provide your own menu to be rendered instead.

```ruby
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.build_menu :utility_navigation do |menu|
      menu.add label: "ActiveAdmin.info", url: "http://www.activeadmin.info", html_options: { target: :blank }
      admin.add_logout_button_to_menu menu # can also pass priority & html_options for link_to to use
    end
  end
end
```
