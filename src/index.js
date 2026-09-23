import express from "express";
import { checkConnection } from "./config/db.js";

const app = express();

app.get("/", (req, res) => {
  res.send(`Server is ready for SHOPFLOW SYSTEM.`);
});

const PORT = 3000;

async function startServer() {
  try {
    await checkConnection();
    app.listen(PORT, () => {
      console.log(`Server is ready for PORT: ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error.message);
    process.exit(1);
  }
}

startServer();
