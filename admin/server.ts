import express from "express";
import methodOverride from "method-override";
import * as path from "path";
import { flashMiddleware } from "./helpers/flash.js";
import { dashboardRoutes } from "./routes/dashboard.js";
import { pointsRoutes } from "./routes/points.js";
import { equipmentRoutes } from "./routes/equipment.js";
import { brandsRoutes } from "./routes/brands.js";
import { typesRoutes } from "./routes/types.js";
import { modelsRoutes } from "./routes/models.js";
import { searchRoutes } from "./routes/search.js";
import { exportRoutes } from "./routes/export.js";
import { apiRoutes } from "./routes/api.js";

const app = express();
const PORT = process.env.PORT || 3000;

// View engine
app.set("view engine", "ejs");
app.set("views", path.join(import.meta.dirname, "views"));

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(import.meta.dirname, "public")));
app.use(methodOverride("_method"));
app.use(flashMiddleware);

// Make current path available to nav
app.use((req, res, next) => {
  res.locals.currentPath = req.path;
  res.locals.isHtmx = req.headers["hx-request"] === "true";
  next();
});

// Routes
app.use("/", dashboardRoutes);
app.use("/points", pointsRoutes);
app.use("/equipment", equipmentRoutes);
app.use("/brands", brandsRoutes);
app.use("/types", typesRoutes);
app.use("/models", modelsRoutes);
app.use("/search", searchRoutes);
app.use("/export", exportRoutes);
app.use("/api", apiRoutes);

app.listen(PORT, () => {
  console.log(`BAS Atlas Admin running at http://localhost:${PORT}`);
});
