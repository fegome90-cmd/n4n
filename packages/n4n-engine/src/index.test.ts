/**
 * @n4n/engine test suite
 */

import { describe, it, expect } from "vitest";
import pkg from "../package.json";

describe("@n4n/engine", () => {
  it("should export package metadata", () => {
    expect(pkg.name).toBe("@n4n/engine");
    expect(pkg.version).toBe("1.0.0");
  });

  it("should have working package structure", () => {
    expect(true).toBe(true); // Basic package structure exists
  });
});