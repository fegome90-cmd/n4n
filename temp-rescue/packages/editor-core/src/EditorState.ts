import { EditorMode } from './EditorMode';

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
 * Create a new EditorState initialized with the given document and mode.
 *
 * @param doc - Document content; defaults to an empty string.
 * @param mode - Editor mode; defaults to EditorMode.INSERT.
 * @returns An EditorState with the provided `doc` and `mode` and a current timestamp.
 */
export function createEditorState(
  doc: string = '',
  mode: EditorMode = EditorMode.INSERT
): EditorState {
  return {
    mode,
    doc,
    timestamp: Date.now()
  };
}

/**
 * Create a new EditorState with updated document content and a strictly increasing timestamp.
 *
 * @param state - The existing EditorState to base the update on
 * @param doc - The new document content
 * @returns The new EditorState whose `doc` is `doc` and whose `timestamp` is greater than the previous state's timestamp
 */
export function withDocument(state: EditorState, doc: string): EditorState {
  const now = Date.now();
  // Ensure different timestamp even if called rapidly
  const currentTimestamp = state.timestamp ?? 0;
  const timestamp = now > currentTimestamp ? now : currentTimestamp + 1;
  return {
    ...state,
    doc,
    timestamp
  };
}

/**
 * Create a new EditorState with the given mode and an updated timestamp.
 *
 * @param state - The existing EditorState to base the new state on
 * @param mode - The EditorMode to set on the new state
 * @returns The new EditorState with `mode` set to `mode` and `timestamp` strictly greater than the previous state's timestamp
 */
export function withMode(state: EditorState, mode: EditorMode): EditorState {
  const now = Date.now();
  // Ensure different timestamp even if called rapidly
  const currentTimestamp = state.timestamp ?? 0;
  const timestamp = now > currentTimestamp ? now : currentTimestamp + 1;
  return {
    ...state,
    mode,
    timestamp
  };
}

/**
 * Checks whether a value conforms to the EditorState shape.
 *
 * @returns `true` if `value` is an EditorState, `false` otherwise.
 */
export function isEditorState(value: unknown): value is EditorState {
  if (!value || typeof value !== 'object') return false;

  const state = value as any;

  // Check required properties exist and have correct types
  return (
    typeof state.mode === 'string' &&
    Object.values(EditorMode).includes(state.mode) &&
    typeof state.doc === 'string' &&
    (state.timestamp === undefined || typeof state.timestamp === 'number')
  );
}