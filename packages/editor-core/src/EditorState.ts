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
 * Create a new editor state with the specified document content and mode.
 *
 * @param doc - The initial document content; defaults to an empty string.
 * @param mode - The initial editor mode; defaults to `EditorMode.INSERT`.
 * @returns A new `EditorState` containing `doc`, `mode`, and a `timestamp` set to the current time.
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
 * Return a new EditorState with updated document content and an advanced timestamp.
 *
 * The returned state has its `doc` replaced by `doc` and its `timestamp` set to the current time,
 * or to the previous timestamp plus one if the previous timestamp is already >= current time,
 * ensuring the new timestamp is strictly greater than the original.
 *
 * @param state - The existing EditorState to base the update on
 * @param doc - The new document content
 * @returns A new EditorState with `doc` set to `doc` and a strictly newer `timestamp`
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
 * Create a new EditorState with the given mode and an updated, monotonically increasing timestamp.
 *
 * @param state - The existing editor state to base the update on
 * @param mode - The new editor mode to set on the returned state
 * @returns A new EditorState with `mode` replaced and `timestamp` set to `Date.now()` or incremented so it is greater than the previous timestamp
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
 * Determine whether a value conforms to the EditorState shape.
 *
 * @param value - The value to test
 * @returns `true` if `value` has a valid `mode`, `doc`, and optional numeric `timestamp`; `false` otherwise.
 */
export function isEditorState(value: unknown): value is EditorState {
  if (!value || typeof value !== "object") return false;

  const state = value as Record<string, unknown>;

  // Check required properties exist and have correct types
  return (
    typeof state.mode === "string" &&
    Object.values(EditorMode).includes(state.mode) &&
    typeof state.doc === "string" &&
    (state.timestamp === undefined || typeof state.timestamp === "number")
  );
}