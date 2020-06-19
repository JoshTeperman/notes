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
