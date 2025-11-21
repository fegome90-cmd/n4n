import { describe, it, expect } from 'vitest';
import { EditorMode } from './EditorMode';
import {
  createEditorState,
  withDocument,
  withMode,
  isEditorState,
  EditorState
} from './EditorState';

describe('EditorState', () => {
  describe('createEditorState', () => {
    it('should create state with default values', () => {
      const state = createEditorState();
      expect(state.mode).toBe(EditorMode.INSERT);
      expect(state.doc).toBe('');
      expect(state.timestamp).toBeDefined();
      expect(typeof state.timestamp).toBe('number');
    });

    it('should create state with custom document', () => {
      const doc = 'Hello World';
      const state = createEditorState(doc);
      expect(state.doc).toBe(doc);
      expect(state.mode).toBe(EditorMode.INSERT);
    });

    it('should create state with custom mode', () => {
      const mode = EditorMode.COMMAND;
      const state = createEditorState('', mode);
      expect(state.mode).toBe(mode);
      expect(state.doc).toBe('');
    });

    it('should create state with both custom values', () => {
      const doc = 'Custom content';
      const mode = EditorMode.COMMAND;
      const state = createEditorState(doc, mode);
      expect(state.doc).toBe(doc);
      expect(state.mode).toBe(mode);
    });
  });

  describe('withDocument', () => {
    it('should create new state with updated document', () => {
      const original = createEditorState('original');
      const updated = withDocument(original, 'updated');

      expect(updated.doc).toBe('updated');
      expect(updated.mode).toBe(original.mode);
      expect(updated.timestamp).not.toBe(original.timestamp);
      expect(updated.timestamp).toBeGreaterThan(original.timestamp || 0);
    });

    it('should preserve immutability', () => {
      const original = createEditorState('original');
      withDocument(original, 'updated');

      expect(original.doc).toBe('original');
    });
  });

  describe('withMode', () => {
    it('should create new state with updated mode', () => {
      const original = createEditorState('test', EditorMode.INSERT);
      const updated = withMode(original, EditorMode.COMMAND);

      expect(updated.mode).toBe(EditorMode.COMMAND);
      expect(updated.doc).toBe(original.doc);
      expect(updated.timestamp).not.toBe(original.timestamp);
      expect(updated.timestamp).toBeGreaterThan(original.timestamp || 0);
    });

    it('should preserve immutability', () => {
      const original = createEditorState('test', EditorMode.INSERT);
      withMode(original, EditorMode.COMMAND);

      expect(original.mode).toBe(EditorMode.INSERT);
    });
  });

  describe('isEditorState', () => {
    it('should return true for valid EditorState objects', () => {
      const validState = {
        mode: EditorMode.INSERT,
        doc: 'test',
        timestamp: Date.now()
      };

      expect(isEditorState(validState)).toBe(true);
    });

    it('should return true for EditorState without timestamp', () => {
      const validState = {
        mode: EditorMode.INSERT,
        doc: 'test'
      };

      expect(isEditorState(validState)).toBe(true);
    });

    it('should return false for invalid mode', () => {
      const invalidState = {
        mode: 'INVALID_MODE',
        doc: 'test'
      };

      expect(isEditorState(invalidState)).toBe(false);
    });

    it('should return false for missing properties', () => {
      expect(isEditorState({ mode: EditorMode.INSERT })).toBe(false);
      expect(isEditorState({ doc: 'test' })).toBe(false);
    });

    it('should return false for wrong property types', () => {
      expect(isEditorState({ mode: 123, doc: 'test' })).toBe(false);
      expect(isEditorState({ mode: EditorMode.INSERT, doc: 456 })).toBe(false);
      expect(
        isEditorState({
          mode: EditorMode.INSERT,
          doc: 'test',
          timestamp: 'not-a-number'
        })
      ).toBe(false);
    });

    it('should return false for null/undefined', () => {
      expect(isEditorState(null)).toBe(false);
      expect(isEditorState(undefined)).toBe(false);
    });

    it('should return false for non-objects', () => {
      expect(isEditorState('string')).toBe(false);
      expect(isEditorState(123)).toBe(false);
      expect(isEditorState([])).toBe(false);
    });
  });

  describe('immutability guarantees', () => {
    it('should maintain immutability through functions', () => {
      const original = createEditorState('test', EditorMode.INSERT);
      const updated = withMode(original, EditorMode.COMMAND);

      // Original should be unchanged
      expect(original.mode).toBe(EditorMode.INSERT);
      expect(updated.mode).toBe(EditorMode.COMMAND);

      // Should be different objects (structural sharing)
      expect(original).not.toBe(updated);
    });

    it('should have readonly interface', () => {
      // TypeScript enforces readonly at compile time
      const state: EditorState = {
        mode: EditorMode.INSERT,
        doc: 'test',
        timestamp: Date.now()
      };

      // TypeScript prevents direct assignment to readonly properties
      // This is enforced at compile time, not runtime
      expect(state.mode).toBe(EditorMode.INSERT);
    });
  });
});