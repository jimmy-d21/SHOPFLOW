import pg from "pg";
import ENV from "./env.js";

const { Pool } = pg;

const { host, port, user, password, database_name } = ENV.database;

const db = new Pool({
  host,
  port,
  user,
  password,
  database: database_name,
});

const checkConnection = async () => {
  try {
    const client = await db.connect();
    console.log(`Database connected successfully`);
    client.release();
  } catch (error) {
    console.error(`Error connecting to database: ${error.message}`);
    process.exit(1);
  }
};

export { db as default, checkConnection };
