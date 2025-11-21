import { describe, it, expect } from "vitest";
import * as EditorCore from "./index";

describe("Editor Core Index - Barrel Exports", () => {
  describe("EditorMode exports", () => {
    it("should export EditorMode enum", () => {
      expect(EditorCore.EditorMode).toBeDefined();
      expect(EditorCore.EditorMode.INSERT).toBe("INSERT");
      expect(EditorCore.EditorMode.COMMAND).toBe("COMMAND");
    });

    it("should export Mode alias", () => {
      expect(EditorCore.EditorMode).toBeDefined();
    });

    it("should export EditorModeType type", () => {
      // Type test - should compile if type is exported
      const mode: EditorCore.EditorModeType = EditorCore.EditorMode.INSERT;
      expect(mode).toBe(EditorCore.EditorMode.INSERT);
    });

    it("should export isEditorMode function", () => {
      expect(EditorCore.isEditorMode).toBeDefined();
      expect(typeof EditorCore.isEditorMode).toBe("function");
      expect(EditorCore.isEditorMode(EditorCore.EditorMode.INSERT)).toBe(true);
    });

    it("should export getDefaultEditorMode function", () => {
      expect(EditorCore.getDefaultEditorMode).toBeDefined();
      expect(typeof EditorCore.getDefaultEditorMode).toBe("function");
      expect(EditorCore.getDefaultEditorMode()).toBe(
        EditorCore.EditorMode.INSERT
      );
    });
  });

  describe("EditorState exports", () => {
    it("should export createEditorState function", () => {
      expect(EditorCore.createEditorState).toBeDefined();
      expect(typeof EditorCore.createEditorState).toBe("function");
    });

    it("should export withDocument function", () => {
      expect(EditorCore.withDocument).toBeDefined();
      expect(typeof EditorCore.withDocument).toBe("function");
    });

    it("should export withMode function", () => {
      expect(EditorCore.withMode).toBeDefined();
      expect(typeof EditorCore.withMode).toBe("function");
    });

    it("should export isEditorState function", () => {
      expect(EditorCore.isEditorState).toBeDefined();
      expect(typeof EditorCore.isEditorState).toBe("function");
    });

    it("should export EditorState type", () => {
      // Type test - should compile if type is exported
      const state: EditorCore.EditorState =
        EditorCore.createEditorState("test");
      expect(state.doc).toBe("test");
      expect(state.mode).toBe(EditorCore.EditorMode.INSERT);
    });

    it("should export State type alias", () => {
      // Type test - should compile if type alias works
      const state: EditorCore.State = EditorCore.createEditorState("test");
      expect(state.doc).toBe("test");
    });
  });

  describe("integration", () => {
    it("should work together as complete API", () => {
      const mode = EditorCore.getDefaultEditorMode();
      const state = EditorCore.createEditorState("Hello World", mode);

      expect(EditorCore.isEditorMode(mode)).toBe(true);
      expect(EditorCore.isEditorState(state)).toBe(true);

      const newMode = EditorCore.EditorMode.COMMAND;
      const newState = EditorCore.withMode(state, newMode);

      expect(newState.mode).toBe(newMode);
      expect(newState.doc).toBe(state.doc);
      expect(newState.timestamp).not.toBe(state.timestamp);
    });
  });

  describe("type consistency", () => {
    it("should have consistent Mode and EditorMode types", () => {
      const mode: EditorCore.EditorMode = EditorCore.EditorMode.INSERT;
      const alias: EditorCore.Mode = mode; // Should be assignable
      expect(alias).toBe(mode);
    });

    it("should have consistent State and EditorState types", () => {
      const state: EditorCore.EditorState = EditorCore.createEditorState();
      const alias: EditorCore.State = state; // Should be assignable
      expect(alias).toBe(state);
    });
  });
});
