import { describe, it, expect } from 'vitest';
import { EditorMode, isEditorMode, getDefaultEditorMode } from './EditorMode';

describe('EditorMode', () => {
  describe('enum values', () => {
    it('should have INSERT mode', () => {
      expect(EditorMode.INSERT).toBe('INSERT');
    });

    it('should have COMMAND mode', () => {
      expect(EditorMode.COMMAND).toBe('COMMAND');
    });
  });

  describe('isEditorMode', () => {
    it('should return true for valid EditorMode values', () => {
      expect(isEditorMode(EditorMode.INSERT)).toBe(true);
      expect(isEditorMode(EditorMode.COMMAND)).toBe(true);
    });

    it('should return false for invalid values', () => {
      expect(isEditorMode('INVALID')).toBe(false);
      expect(isEditorMode('insert')).toBe(false); // case sensitive
      expect(isEditorMode('')).toBe(false);
      expect(isEditorMode(null)).toBe(false);
      expect(isEditorMode(undefined)).toBe(false);
      expect(isEditorMode(123)).toBe(false);
      expect(isEditorMode({})).toBe(false);
    });
  });

  describe('getDefaultEditorMode', () => {
    it('should return INSERT as default mode', () => {
      expect(getDefaultEditorMode()).toBe(EditorMode.INSERT);
    });
  });

  describe('immutability', () => {
    it('should have consistent enum values', () => {
      // TypeScript enums provide compile-time immutability
      const originalInsert = EditorMode.INSERT;
      const originalCommand = EditorMode.COMMAND;

      // Values should remain consistent
      expect(EditorMode.INSERT).toBe(originalInsert);
      expect(EditorMode.COMMAND).toBe(originalCommand);
      expect(EditorMode.INSERT).toBe('INSERT');
      expect(EditorMode.COMMAND).toBe('COMMAND');
    });
  });
});