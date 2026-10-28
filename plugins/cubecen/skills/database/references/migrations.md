# Migrations on Cubecen

Run them when the cube starts, before the server: every deploy then
migrates, and nothing needs the password. Use the unpooled URL where the
tool needs a direct connection.

| Tool | Start command or script | Notes |
|---|---|---|
| Prisma | `"start": "prisma migrate deploy && node server.js"` | `prisma` in `dependencies`; set `directUrl = env("DATABASE_URL_UNPOOLED")` in the datasource and `DATABASE_URL_UNPOOLED = ${{ <slug>.DATABASE_URL_UNPOOLED }}` on the cube; `prisma generate` in the build |
| Drizzle | `"start": "drizzle-kit migrate && node server.js"`, or `migrate()` from `drizzle-orm/node-postgres/migrator` at start | the config's `dbCredentials.url` from `DATABASE_URL_UNPOOLED` |
| TypeORM | `typeorm migration:run -d dist/data-source.js && node dist/main.js` | or `migrationsRun: true` |
| Sequelize | `sequelize-cli db:migrate && node server.js` | |
| Knex | `knex migrate:latest && node server.js` | |
| Django | `python manage.py migrate --noinput && gunicorn <project>.wsgi -b 0.0.0.0:$PORT` | `DATABASES` from `DATABASE_URL` (`dj-database-url`) |
| Rails | `bin/rails db:prepare && bundle exec puma -C config/puma.rb` | |
| Alembic (SQLAlchemy) | `alembic upgrade head && uvicorn main:app --host 0.0.0.0 --port $PORT` | `sqlalchemy.url` from the environment |
| golang-migrate | `migrate -path migrations -database "$DATABASE_URL_UNPOOLED" up && ./server` | or embedded with `migrate.NewWithSourceInstance` |
| Laravel | `php artisan migrate --force && …` | `DB_URL` from the reference |

## A one-off run from this machine

Only when the user asks for it (a seed, a data fix):

1. Say what will run, against which database, and wait for a yes.
2. By default the user runs it: give them the command, with the
   connection string from the database's page in the dashboard.
3. When they want you to run it: `get_database_connection` answers
   `database_url_unpooled`. Write `DATABASE_URL=<that URL>` with the file
   tool to a new file outside the repository (in the system's temp
   directory), run `set -a; . <file>; set +a; <command>` so the URL is in
   no command line, then delete the file.
4. Never print the URL or the password in the conversation.
