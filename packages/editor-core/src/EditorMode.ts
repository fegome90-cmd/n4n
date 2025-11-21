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
  INSERT = 'INSERT',

  /** Execute commands and navigation */
  COMMAND = 'COMMAND'
}

/**
 * Type guard to check if a value is a valid EditorMode
 */
export function isEditorMode(value: unknown): value is EditorMode {
  return Object.values(EditorMode).includes(value as EditorMode);
}

/**
 * Get default mode for new editor instances
 */
export function getDefaultEditorMode(): EditorMode {
  return EditorMode.INSERT;
}