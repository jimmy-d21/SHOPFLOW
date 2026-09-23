import "dotenv/config";

const { PORT, NODE_ENV, DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME } =
  process.env;

const ENV = Object.freeze({
  server: {
    port: PORT,
    node_env: NODE_ENV,
  },
  database: {
    host: DB_HOST,
    port: DB_PORT,
    user: DB_USER,
    password: DB_PASSWORD,
    database_name: DB_NAME,
  },
});

export default ENV;
