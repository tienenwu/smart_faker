# CLAUDE.md - SmartFaker Package Development Guide

## 🎯 Maintaining Perfect pub.dev Score (160/160)

### Pre-Release Checklist

Before publishing any new version, follow this checklist to maintain the perfect 160/160 pub.dev score:

#### 1. **Code Quality (40 points)**
```bash
# Run dart analyzer - MUST have zero issues
dart analyze

# Fix any linting issues
dart fix --apply

# Format all code
dart format .
```

#### 2. **Documentation (30 points)**
- [ ] All public APIs have dartdoc comments
- [ ] Check documentation coverage:
```bash
# Generate docs and check coverage
dart doc .
# Look for "Documented: X%" - must be 100%
```

- [ ] Every public class, method, and property needs:
  - Brief description (first line)
  - Parameter descriptions (if applicable)
  - Return value description (if applicable)
  - Example usage (for complex APIs)

#### 3. **Platform Support (20 points)**
- [ ] Verify `pubspec.yaml` has proper SDK constraints:
```yaml
environment:
  sdk: ^3.5.0
  flutter: ">=3.0.0"
```
- [ ] Support multiple platforms if applicable

#### 4. **Dependencies (20 points)**
- [ ] Use latest stable versions
- [ ] Minimize dependencies
- [ ] Use version ranges (^) not exact versions
```bash
# Check for outdated dependencies
dart pub outdated
```

#### 5. **Package Metadata (20 points)**
Required in `pubspec.yaml`:
- [ ] `description` (60-180 characters)
- [ ] `repository` (GitHub URL)
- [ ] `homepage` or `repository`
- [ ] `version` (follow semantic versioning)
- [ ] `topics` (up to 5, optional but recommended)

#### 6. **Example Directory (20 points)**
- [ ] Must have `/example` directory
- [ ] Include runnable examples
- [ ] Examples should demonstrate main features
```bash
# Test examples work
cd example
dart run smart_faker_example.dart
```

#### 7. **CHANGELOG.md (10 points)**
- [ ] Document all changes for new version
- [ ] Follow format:
```markdown
## [version] - YYYY-MM-DD

### Added
- New features

### Changed
- Modified features

### Fixed
- Bug fixes

### Breaking Changes (if any)
- List breaking changes
```

### Version Bump Process

1. **Update version in `pubspec.yaml`**:
   - MAJOR.MINOR.PATCH (e.g., 0.2.0)
   - MAJOR: Breaking changes
   - MINOR: New features (backwards compatible)
   - PATCH: Bug fixes only

2. **Update CHANGELOG.md**:
   - Add new version section at top
   - List all changes clearly

3. **Update README.md**:
   - Update version number
   - Update installation instructions
   - Add examples for new features

4. **Final Checks**:
```bash
# Ensure all tests pass
dart test

# Analyze code
dart analyze

# Format code
dart format .

# Check pub score locally
dart pub publish --dry-run
```

5. **Publish**:
```bash
# When everything passes
dart pub publish
```

### Common Issues That Reduce Score

#### Documentation Issues
- Missing dartdoc comments on public APIs
- Incomplete parameter descriptions
- No examples in complex APIs

#### Code Issues
- Unused imports
- Redundant code (like duplicate default cases)
- Formatting issues
- Linting warnings

#### Example Issues
- Missing `/example` directory
- Non-runnable examples
- Examples don't demonstrate key features

### Quick Fix Commands

```bash
# Fix most common issues automatically
dart fix --apply && dart format . && dart analyze

# Check documentation coverage
dart doc . 2>&1 | grep "Documented:"

# Test everything before publish
dart test && dart analyze && dart format --set-exit-if-changed .
```

### Emergency Fixes After Publishing

If score drops after publishing:
1. Fix issues immediately
2. Publish patch version (e.g., 0.2.1)
3. Update CHANGELOG with fixes
4. Re-run all checks before publishing

### Version 0.2.0 Specific Notes

For SmartFaker v0.2.0, ensure:
- Export module is fully documented
- Taiwan module has complete API docs
- All new public methods have dartdoc
- Examples demonstrate new features
- CHANGELOG lists all new features

---
*Last Updated: 2025-09-08*
*Maintaining pub.dev score: 160/160*