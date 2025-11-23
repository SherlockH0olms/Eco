# Contributing to SMA Physio Game

First off, thank you for considering contributing! ❤️

## How Can I Contribute?

### Reporting Bugs

1. **Check existing issues** to avoid duplicates
2. **Use issue template** with:
   - Device and OS version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots/videos if applicable

### Suggesting Features

1. **Open a discussion** first to get feedback
2. **Explain use case**: Who needs this and why?
3. **Consider scope**: Does it fit the MVP/roadmap?

### Code Contributions

#### Development Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/Eco.git
cd Eco

# Create branch
git checkout -b feature/your-feature-name

# Install dependencies
flutter pub get

# Make changes and test
flutter test
flutter run
```

#### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Run formatter: `flutter format .`
- Run analyzer: `flutter analyze`
- Write meaningful commit messages

#### Pull Request Process

1. **Update documentation** if adding features
2. **Add tests** for new functionality
3. **Ensure all tests pass**: `flutter test`
4. **Update README** if needed
5. **Reference related issues** in PR description

### Areas Needing Help

- 🌍 **Translations**: Add support for more languages
- 🎨 **UI/UX**: Improve accessibility and design
- 🧪 **Testing**: Write more unit/widget tests
- 📝 **Documentation**: Improve guides and tutorials
- 🎮 **Exercises**: Add new exercise types
- 🤖 **AI**: Improve pose detection accuracy

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of:
- Age, disability, ethnicity
- Gender identity and expression
- Level of experience
- Nationality, personal appearance
- Race, religion, or sexual identity

### Our Standards

**Positive behavior:**
- Being respectful and empathetic
- Giving and accepting constructive feedback
- Focusing on what's best for the community

**Unacceptable behavior:**
- Harassment, trolling, or insulting comments
- Public or private harassment
- Publishing others' private information
- Any conduct inappropriate in a professional setting

### Enforcement

Violations can be reported to project maintainers. All complaints will be reviewed and investigated promptly and fairly.

## Development Guidelines

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Example:**
```
feat(game): add shoulder rotation exercise

Implement pose detection for shoulder rotation exercise
with appropriate angle thresholds and feedback.

Closes #42
```

### Testing Requirements

- **Unit tests** for all services
- **Widget tests** for complex widgets
- **Integration tests** for critical flows
- Minimum **80% code coverage** for new code

### Documentation

- Add doc comments for public APIs
- Update README for new features
- Include examples in code comments
- Keep CHANGELOG.md updated

## Questions?

Feel free to:
- Open a discussion on GitHub
- Comment on existing issues
- Reach out to maintainers

Thank you for making SMA Physio Game better! 🚀
