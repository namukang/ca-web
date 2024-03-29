## Overview

`ca-web` is the Rails app for managing user accounts. See [`ca-socket`](https://github.com/dskang/ca-socket) for the Node.js service for matching users and powering chats.

## Development

We want to simulate the production environment's subdomains (for passing cookies between `ca-web` and `ca-socket`), so add the following in your `/etc/hosts`:

```
127.0.0.1 www.ca.local
127.0.0.1 socket.ca.local
```

Develop using the domains above rather than `localhost`.

### Email

By default, our development environment sends emails to `localhost:1025`. We use [`mailcatcher`](http://mailcatcher.me/) to catch and display our emails.

```bash
gem install mailcatcher
mailcatcher
```

## Staging

Set up your staging environment on Heroku. We will assume the names `ca-web-staging` and `ca-socket-staging` for the `ca-web` app and `ca-socket` app, respectively. For your Heroku app names, make sure they're identical except for the words "web" and "socket".

```bash
# ca-web
heroku create ca-web-staging
heroku git:remote -a ca-web-staging -r staging
git push staging master
heroku run rake db:migrate -a ca-web-staging
heroku run rake db:seed -a ca-web-staging
# Add Mandrill to send emails
heroku addons:add mandrill -a ca-web-staging

# ca-socket
heroku create ca-socket-staging
heroku git:remote -a ca-socket-staging -r staging
git push staging master
heroku config:set NODE_ENV=staging -a ca-socket-staging
# Add Redis To Go to store user data
heroku addons:add redistogo -a ca-socket-staging
```

You're done!

### Testing a feature branch

If you want to push a branch you're testing to staging, run `git push staging feature-branch:master`.

### Caveats

Since we cannot pass cookies between Heroku apps, `ca-socket` will accept any connection and will generate a random email address for each connection. Therefore, you can't test functionality that requires `ca-socket` to know the user set on `ca-web`'s cookie.

## Production

Both `ca-web` and `ca-socket` run on Heroku.
`www.campusanonymous.com` points to `ca-web` and `socket.campusanonymous.com` points to `ca-socket`.

Only the master branch should ever be pushed to production. All other testing should occur in development or in staging.
