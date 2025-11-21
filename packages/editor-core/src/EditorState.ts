import { EditorMode } from "./EditorMode";

/**
 * Editor State - Domain Interface
 *
 * Represents the complete state of the editor instance.
 * Contains current mode and document content.
 *
 * This is an immutable interface - state changes create new instances.
 */
export interface EditorState {
  /** Current editor mode (INSERT or COMMAND) */
  readonly mode: EditorMode;

  /** Document content as plain string */
  readonly doc: string;

  /** Optional metadata for state tracking */
  readonly timestamp?: number;
}

/**
 * Create a new EditorState with default values
 */
export function createEditorState(
  doc: string = "",
  mode: EditorMode = EditorMode.INSERT
): EditorState {
  return {
    mode,
    doc,
    timestamp: Date.now(),
  };
}

/**
 * Create new EditorState by updating document content
 */
export function withDocument(state: EditorState, doc: string): EditorState {
  const now = Date.now();
  // Ensure different timestamp even if called rapidly
  const currentTimestamp = state.timestamp ?? 0;
  const timestamp = now > currentTimestamp ? now : currentTimestamp + 1;
  return {
    ...state,
    doc,
    timestamp,
  };
}

/**
 * Create new EditorState by changing mode
 */
export function withMode(state: EditorState, mode: EditorMode): EditorState {
  const now = Date.now();
  // Ensure different timestamp even if called rapidly
  const currentTimestamp = state.timestamp ?? 0;
  const timestamp = now > currentTimestamp ? now : currentTimestamp + 1;
  return {
    ...state,
    mode,
    timestamp,
  };
}

/**
 * Type guard to check if a value is a valid EditorState
 */
export function isEditorState(value: unknown): value is EditorState {
  if (!value || typeof value !== "object") return false;

  const state = value as any;

  // Check required properties exist and have correct types
  return (
    typeof state.mode === "string" &&
    Object.values(EditorMode).includes(state.mode) &&
    typeof state.doc === "string" &&
    (state.timestamp === undefined || typeof state.timestamp === "number")
  );
}
