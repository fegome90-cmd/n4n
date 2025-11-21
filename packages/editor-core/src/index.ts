/**
 * Editor Core Package - Public API
 *
 * Provides core editor functionality without external dependencies.
 * Exported types and utilities are domain-agnostic and UI-agnostic.
 */

// Core Types
export { EditorMode, isEditorMode, getDefaultEditorMode } from "./EditorMode";
export type { EditorMode as EditorModeType } from "./EditorMode";

export {
  createEditorState,
  withDocument,
  withMode,
  isEditorState,
} from "./EditorState";
export type { EditorState } from "./EditorState";

// Re-export for convenience
export type { EditorState as State } from "./EditorState";

export { EditorMode as Mode } from "./EditorMode";
