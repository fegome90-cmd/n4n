import { EditorMode, EditorState } from '@n4n/editor-core';

/**
 * Command Context - Domain Interface
 *
 * Provides necessary state and callbacks for command execution.
 * Commands operate on this context to modify editor state.
 */
export interface CommandContext {
  /** Get current editor state */
  getEditorState(): EditorState;

  /** Update editor document content */
  updateDocument(content: string): void;

  /** Change editor mode */
  setMode(mode: EditorMode): void;

  /** Get current editor mode */
  getMode(): EditorMode;

  /** Insert text at current cursor position */
  insertText(text: string): void;

  /** Execute editor action (undo, redo, etc.) */
  executeAction(action: string): void;
}

/**
 * Command Handler Function Type
 *
 * Function that executes a command with given context.
 * Should return success status and optional error message.
 */
export type CommandHandler = (
  context: CommandContext
) => {
  success: boolean;
  error?: string;
};

/**
 * Command - Domain Interface
 *
 * Represents an executable command in command palette.
 * Commands have unique IDs, display labels, and execution handlers.
 */
export interface Command {
  /** Unique identifier for command */
  readonly id: string;

  /** Human-readable display label */
  readonly label: string;

  /** Optional description for help tooltips */
  readonly description?: string;

  /** Keyboard shortcut (optional) */
  readonly shortcut?: string;

  /** Function that executes the command */
  readonly handler: CommandHandler;

  /** Optional category for organization */
  readonly category?: string;
}

/**
 * Type guard to check if a value is a valid Command
 */
export function isCommand(value: unknown): value is Command {
  if (!value || typeof value !== 'object') return false;

  const cmd = value as any;

  return (
    typeof cmd.id === 'string' &&
    typeof cmd.label === 'string' &&
    typeof cmd.handler === 'function' &&
    (cmd.description === undefined || typeof cmd.description === 'string') &&
    (cmd.shortcut === undefined || typeof cmd.shortcut === 'string') &&
    (cmd.category === undefined || typeof cmd.category === 'string')
  );
}