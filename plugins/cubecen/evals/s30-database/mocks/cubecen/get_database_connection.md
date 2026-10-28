The connection holds the password: do not show it unless the user asks. Cubes need none of it: set_env DATABASE_URL = ${{ shop-db.DATABASE_URL }}

{
  "host": "ep-shop-db.eu-central-1.aws.neon.tech",
  "user": "app",
  "password": "s3cr3t-db-pass",
  "database_url": "postgresql://app:s3cr3t-db-pass@ep-shop-db-pooler.eu-central-1.aws.neon.tech/shop?sslmode=require"
}
