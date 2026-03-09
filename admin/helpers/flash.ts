import type { Request, Response, NextFunction } from "express";

export function flashMiddleware(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const flashType = req.query.flash_type as string | undefined;
  const flashMsg = req.query.flash_msg as string | undefined;
  if (flashType && flashMsg) {
    res.locals.flash = { type: flashType, msg: flashMsg };
  }
  next();
}

export function flashRedirect(
  basePath: string,
  type: "success" | "error",
  msg: string,
): string {
  return `${basePath}?flash_type=${type}&flash_msg=${encodeURIComponent(msg)}`;
}
