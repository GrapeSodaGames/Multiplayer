# Code Review
## Process
- Not testing (do that too though!)
- Less than 400 lines per review
- only review 1 an hour
- Test edge cases
- Annotate!

## Categories
### Correctness
- Does it do what it's supposed to do?
- Does it use the language idiomatically to do it?

### Readability
- Is the code clean?
    - any methods > 10 LOC? (Code Smell - Long Method)
    - are there any unnecessary comments? (Code Smell - Comments)
    - use of primitives instead of objects for special values (Code Smell - Primitive Obsession)
    - are there any methods with more than 4 parameters? (Code Smell - Long Parameter List)
    - are there any match or switch statements, or a complex sequence of ifs? (Code Smell - Switch Statement)
    - any fields initialized empty and only filled sometimes? (Code Smell - Temporary Field)
    - any code duplicated, or very close to duplicated? (Code Smell - Duplicate Code)
    - any class contain only fields and getters/setters? (Code Smell - Data Class)
    - any code created "just in case?" (Code Smell - Speculative Generality)
    - any code using the internal fields and methods of another class? (Code Smell - Inappropriate Intimacy)

### Maintainability
- How portable is it?
    - private variables prefixed with _
    - private methods prefixed with _
    - no data properties exposed globally
- Does it have tests?
- Does it have docs?
- Does it add any dependencies?
- Does it use existing dependencies?
- Does it conform to SOLID Principles?
    - Single Responsibility Principle
    - Open-Closed Principle
    - Liskov substitution Principle
    - Interface Segregation Principle
    - Dependency inversion Principle

### Performance
- Does it add code to _process() or _physics_process()?
- Is it noticeably slower?

### Style and Consistency
- Does it conform to the gdformat and gdlinter rules?
    - we are using a github action to enforce this
