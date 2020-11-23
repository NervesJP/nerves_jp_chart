# assign a default for the database_user
DB_USER=postgres

# wait until Postgres is ready
while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/nerves_jp_chart"
# start the elixir application
eval "$bin eval \"NervesJpChart.Release.migrate\""
exec "$bin" "start"