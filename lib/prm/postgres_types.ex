# Enable PostGIS for Ecto
Postgrex.Types.define(
  EHealth.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison
)
