# pendek

Pendek: a dead simple base36 URL minifier-redirector. Named after the
particularly short, cryptid sasquatch of Sumatra.

Ruby 2.1.2 and rails 4.1.8.

```
> git clone https://github.com/buermann/pendek.git ./pendek
> cd pendek
> bundle install
> bundle exec rake db:create db:migrate
> bundle exec rake db:create db:migrate RAILS_ENV=test
> bundle exec rspec
> bundle exec rails s
```

And browse to http://127.0.0.1:3000/

