/**
 * Editor Mode - Domain Type
 *
 * Defines possible modes of the text editor.
 * Each mode determines what keystrokes do and how editor behaves.
 *
 * INSERT: Normal text editing mode, keystrokes insert characters
 * COMMAND: Command execution mode, keystrokes trigger commands
 */
export enum EditorMode {
  /** Insert text into document */
  INSERT = "INSERT",

  /** Execute commands and navigation */
  COMMAND = "COMMAND",
}

/**
 * Determines whether a value is a valid EditorMode.
 *
 * @param value - Value to test
 * @returns `true` if `value` is a valid EditorMode, `false` otherwise.
 */
export function isEditorMode(value: unknown): value is EditorMode {
  return Object.values(EditorMode).includes(value as EditorMode);
}

/**
 * Provide the default editor mode for new editor instances.
 *
 * @returns The default EditorMode, `EditorMode.INSERT`.
 */
export function getDefaultEditorMode(): EditorMode {
  return EditorMode.INSERT;
}