/**
 * N4N Engine - Command System Package Public API
 *
 * Provides command registry, execution context, and command interfaces.
 * Domain-agnostic and UI-agnostic command system foundation.
 */

// Core Types
export type { EditorMode, EditorState } from './Command';
export {
  Command,
  CommandContext,
  CommandHandler,
  isCommand
} from './Command';

// Re-export for convenience
export type { Command as CommandInterface } from './Command';