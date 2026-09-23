import express from "express";

const app = express();

app.get("/", (req, res) => {
  res.send(`Server is ready for SHOPFLOW SYSTEM.`);
});

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Server is ready on PORT: ${PORT}`);
});
