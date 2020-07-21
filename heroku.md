## Commands

`heroku login --interactive`
`heroku create`
`git push heroku master`
`heroku logs`
`heroku logs --tail`

When pushing an updated brnach to Heroku that includes migrations, it will be in an invalid state while the migration runs, so best to set Heroku to maintenance mode before pushing. This will show a standard error page during deployment and migration.

```
heroku maintenance:on
git push heroku
heroku run rails db:migrate
heroku maintenance:off
```

## Reset the database

Note: `user` has no privileges when running rake tasks on a Heroku dyno, so `rake db:reset` will return a `FATAL: permission denied` error.

https://devcenter.heroku.com/articles/rake

```
heroku pg:reset DATABASE --confirm <app_name>
heroku run rails db:migrate
heroku run rails db:seed
```
