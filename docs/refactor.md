# Refactoring
notes from refactoring.guru
## Code Smells

### Bloaters

#### Long Method
- Generally, any method longer than 10 lines is too long
- If you feel the need to comment, probably needs to be a new method
Fixes:
- To reduce the length of a method body, use Extract Method
- If local variables and parameters interfere with extraction, use Replace Temp with Query, Introduce Parameter Object, or Preserve Whole Object
- If none of the above help, try moving the entire method to a seperate object via Replace Method with Method Object
- Conditionals and loops are a clue that code can be moved to a separate method.  For conditionals, use Decompose Conditional.  If loops are in the way, try Extract Method.

#### Large Class
- Class is too large (needs definition)
Fixes:
- Extract Class helps if part of the behavior of the large class can be spun off into a separate component
- Extract Subclass helps if part of the behavior of the large class can be implemented in different ways or is used in rare cases.
- Extract Interface helps if it's necessary to have a list of the operations and behaviors that the client can used
- If a larch class is responsible for the GUI, you may try to move some of its data and behavior to a separate domain object.  In doing so, it may be necessary to store copies of some data in two places and keep the data consistent.  Duplicate Observed Data offers a way to do this.

#### Primitive Obsession
- Use of primitives instead of small objects for simple tasks, such as currency, ranges, special strings for phone numbers, Extract
- Use of constants for coding information, such as a constant that maps to an int for lookup purposes
- Use of string constants as field names for use in data arrays (obj\["prop"\] instead of obj.prop)
Fixes:
- If you have a large variety of primitive fields, it may be possible to logically group some of them into their own class.  Even better, move the behavior associated with this data into the class too.  For this task, try Replace Data Value with Object
- If the values of primitive fields are used in method parameters, go with Introduce Parameter Object or Preserve Whole Object
- When complicated data is coded in variables, use Replace Type Code with Class, Replace Type Code with Subclasses, or Replace Type Code with State/Strategy
- If there are arrays among the variables, use Replace Array with Object

#### Long Parameter List
- More than 3 or 4 parameters for a method
Fixes:
- Check what values are passed to parameters.  If some of the arguments are just results of method calls of another object, use Replace Parameter with Method Call.  This object can be placed in the filed of its own class or passed as a method parameter
- Instead of passing a group of data received from another object as parameters, pass the object instelf to the method, by using Preserve Whole Object.
- But if these parameters are coming from different sources, you can pass them as a simgle parameter object via Introduce Parameter Object.

#### Data Clumps
- Different parts of the code contain identical groups of variables.  These clumps should be turned into their own classes.
Fixes:
- If repeating data comprises the fields of a clss, use Extract Class to move the fields to their own class.
- If the same data clumps are passed in the parameters of methods, use Introduce Parameter Object to set them off as a class.
- If some of the data is passed to other methods, think about passing the entire data object to the method instead of just individual fields with Preserve Whole Object.
- Look at the code used by these fields.  It may be a good idea to move this code to a data class.

### Object-Orientation Abusers

#### Alternative Classes with Different Interfaces
- Two classes perform identical functions but have different method names
Fixes:
- Rename Methods to make them identical in all alternative classes
- Move Method, Add Parameter, and Parameterize Method to make the signature and implementation of methods the same
- if only part of the functionality of the classes is duplicated, try using Extract Superclass.  In this case, the existing classes will become subclasses
- After you have determined which method to fix, you may be able to delete one of the classes entirely.

#### Refused Bequest
- If a subclass uses only some of the methods and properties inherited from its parents
Fixes:
- If inheritance makes no sense and the subclass really does have nothing in common with the superclass, eliminate inheritance in favor of Replace Inheritance with Delegation
- If inheritance is appropriate, get rid of unneeded fields and methods in the subclass.  Use Extract Superclass in this case.

#### Switch Statements
- a complex switch or sequence of ifs
Fixes:
- To isolate switch and put it in the right class, you may need Extract Method and then Move Method.
- if a switch is based on type code, such as when the program's runtime mode is switched, use Replace Type Code with Subclasses or Replace Type Code with State/Strategy
- After specifying the inheritance structure, use Replace Conditional with Polymorphism
- If there aren't too many conditions in the operator and they all call the same method with different parameters, polymorphism will be superfluous.  In this case, you can break that method into multiple smaller methods with Replace Parameter with Explicit Methods and change the switch accordingly.
- If one of the conditional options is null, use Introduce Null Object

#### Temporary Field
- fields that are initialized empty, and filled only under certain circumstances.
Fixes:
- Temp fields and all code operating on them can be put in a separate class via Extract Class.  In other words, you're creating a method object, achieving the same result as if you would perform Replace Method with Method Object.
- Introduce Null Object and integrate it in place of the conditional code which was used to check the temporary field values for existence.

### Change Preventers

#### Divergent Change
- You find yourself having to change many unrelated methods when you make changes to a class.
Fixes:
- Split up the behavior of the class via Extract Class
- If different classes have the same behavior, you may want to combine the classes through inheritance with Extract Superclass and Extract Subclass

#### Parallel Inheritance Hierarchies
- Whenever you create a subclass for a class, you find yourself needing to create a subclass for another class.
Fixes:
- First, make instances of one hieracrchy refer to instances of another heirarchy.  Then, remove the hierarchy in the referred class, by using Move Method and Move Field

#### Shotgun Surgery
- Making changes requires many small changes in many different classes
Fixes:
- Use Move Method and Move Field to move existing class behaviors into a single class.  If no existing class is appropriate, create a new component
- If moving code to the same class leaves the original classes almost empty, try to get rid of these now-redundant classes via Inline Class

### Dispensables

#### Comments
- You feel the need to comment a method to make sure it's understood
Fixes:
- If a comment is intended to explain a complex expression, the expression should be split into understandable subexpressions using Extract variables
- If a comment explains a section of code, this section can be turned into a separate method via Extract Method.
- If the method has already been extracted, but comments are still necessary, Rename Method to something more self-explanatory
- If you need to assert rules about a state that's necessary for the system to work, use Introduce Assertion.

#### Duplicate Code
- Two code fragments look almost identical
Fixes:
- if the same code is found in two or more methods in the same class, use Extract Method and place calls for the new method in both places
- if the same code is found in two subclasses of the same level:
    - Use Extract Method for both classes, followed by a Pull Up Field for the fields used in the method that you're pulling up.
    - If the duplicate code is inside a constructor, use Pull Up Constructor Body
    - If the duplicate code is similar but not completely identical, use Form Template Method
    - if two methods do the same thing but use different algorithms, select the best algo and apply Substitute Algorithm
- If duplicate code is found in two different classes:
    - If the classes aren't part of a hierarchy, use Extract Superclass in order to create a single superclass for these classes that maintains all the previous functionality
    - If it's difficult or impossible to create a superclass, use Extract Class in one class and use the new component in the other
- If a large number of conditional expressions are present and perform the same code, differing only in their conditions, merge these operators into a single condition using Consolidate Conditional Expreassion and use Extract Method to place the condition in a separate method with an easy-to-understand name.
- If the same code is performed in all branches of a conditional expression, place the indetical code outside of the condition tree by using Consolidate Duplicate Conditional Fragments

#### Data Class
- A class contains only fields and getters/setters for accessing them
Fixes:
- If a class contains public fields, use Encapsulate Field to hide them from direct accessing
- Use Encapsulate Collection for data stored in collections
- Review the client code that uses the class.  In it, you may find functionality that would be better located in the data class itself.  If this is the case, use Move Method and Extract Method to migrate this functionality to the data class
- After the class has been filled with well thought-out methods, you may want to get rid of old methods for data acces that give overly broad access.  Use Remove Setting Method and Hide Method.

#### Dead Code
- Code that is never reached
Fixes:
- Delete unused code and unneeded files
- In the case of an unnecessary class, Inline Class or Collapse Hierarchy can be applied
- To remove unneeded parameters, use Remove Parameter

#### Lazy Class
- A class doesn't seem to do much
Fixes:
- Components that are near-useless should be given the Inline Class treatment
- For subclases with few functions, try Collapse Hierarchy

#### Speculative Generality
- Code created "just in case" that is unused
Fixes:
- For removing unused abstract classes, try Collapse Hierarchy
- Unnecessary delegation of functionality to another class can be eliminated via Inline Class
- Inline Method for unused methods
- Methods with unused parameters should use Remove Parameter
- unused fields can be deleted

### Couplers

#### Feature Envy
- A method accesses the data of another object more than its own data.
Fixes:
- If a method clearly should be moved to another place, use Move Method
- If only a part of a method accesses the data of another object, use Extract Method to move the part in question
- If a method contains functions from several other classes, first determine which class contains most of the data used.  Then place the method in this class, along with the other data.  Alternatively, use Extract Method to split the method into several parts that can be plaed in different classes.

#### Inappropriate Intimacy
- One class uses the internal fields and methods of another class
Fixes:
- Use Move Method and Move Field to the class in which those parts are used, as long as the first class doesn't rely on these parts
- Another solution is to use Extract Class and Hide Delegate on the class to make the code relations "official"
- If the classes are mutually interdependent, you should use Change Bidirectional Association to Unidirectional
- If this "intimacy" is between a subclass and its superclass, consider Replace Delegation with Inheritance

#### Message Chains
- Information is passed from a -> b -> c -> d
Fixes:
- To delete a message chain, use Hide Delegate
- Sometimes it's better to think of why the end object is being used.  Perhaps it would make sense to use Extract Method for this functionality and move it to the beginning of the chain, by using Move Method.

#### Middle Man
- A class does nothing but delegate work to another class
Fixes:
- Remove Middle Man

#### Incomplete Library Class
- read-only library no longer meets user needs
Fixes:
- for small changes, use Introduce Foreign Method
- for large changes, use Introduce Local Extension

## Refactoring Techniques
### Composing Methods
#### Extract Method
Criteria:
- You have two or more lines in a method that can be grouped together
Action:
- Move this code to a new method, and replace the old code with a call to the method

#### Inline Method
Criteria:
- A method's name is more complicated than just showing the method body (typically one line)
Action:
- Replace calls to the method with the method's body and delete the method itself

#### Extract Variable
Criteria:
- You have an expression that's hard to understand
Action:
- Place the result of the expression or its parts in separate variables that are self-explanatory

#### Inline Temp
Criteria:
- You have a temporary variable that is assigned the result of a simple expression and nothing more
Action:
- Replace the references to the variable with the expression itself

#### Replace Temp with Query
Criteria:
- You place the result of an expression in a local variable for later use in your code
Action:
- Move the entire expression to a separate method and return the result from it in place of using the variable.

#### Split Temporary Variable
Criteria:
- You have a single local variable that's used to store various intermediate values in a method
Action:
- Use different variables for different values.

#### Remove Assignments to Parameters
Criteria:
- A value is assigned to a parameter inside a method body
Action:
- Use a local variable instead of a parameter

#### Replace Method with Method Object
Criteria:
- You have a long method in which the local variables are so intertwined that you can't apply Extract Method
Action:
- Transform the method into a separate class so that the local variables become fields of the class.  Then you can split the method into several methods within the same class.

#### Substitute Algorithm
Criteria:
- An existing algorithm needs to be replaced
Action:
- Replace the body of the function that implements the algorithm

### Moving Features between Objects
#### Move Method
Criteria:
- A method is used more in another class than in its own class
Action:
- Create a new method in the class that uses the method the most, then move code from the old method to this new one.  Turn the code of the original method into a reference to the new method in the other class or remove it entirely

#### Move Field
Criteria:
- A field is used more in another class than in its own class
Action:
- Create a field in a new class and redirect all users of the old field to it

#### Extract Class
Criteria:
- When one class should be two
Action:
- Create a new class

#### Inline Class
Criteria:
- A class does almost nothing
Action:
- Move all featurs to another class and delete

#### Hide Delegate
Criteria:
- The client gets object B from a field or method of object A.  Then the client calls a method of object B
Action:
- Create a new method in class A that delegates the call to object B.  Now the client doesn't know about or depend on class B.

#### Remove Middle Man
Criteria:
- A class has too many methods that simple delegate to other objects
Action:
- Delete these methods and force the client to call the end methods directly

#### Introduce Foreign Method
Criteria:
- A read-only library doesn't contain the method you need
Action:
- Add the method to a client class and pass an object of the library class to it as an argument

#### Introduce Local Extension
Criteria:
- A read-only library doesn't contain many methods you don't need
Action:
- Create a new class containing the methods and make it either the child or wrapper of the utility class

### Organizing Data
#### Change Value to Reference
Criteria:
- replace many instances of a single class with a single object that shares data
Action:
- Convert the many instances into a single objects

#### Change Reference to Value
Criteria:
- You have a reference object that's too small and infrequently changed to justify managing its life cycle
Action:
- Convert the reference object into an instanced value object

#### Duplicate Observed Data
Criteria:
- domain data is stored in classes responsible for the GUI
Action:
- Separate the data into two separate classes and ensure connection and synchronization between GUI and domain

#### Self Encapsulate Field
Criteria:
- You use direct access to private fields inside a class
Action:
- Create a getter and setter for the field and only use them for accessing the field

#### Replace Data Value with Object
Criteria:
- A class or group of classes contains a data field that also has its own behavior and associated data
Action:
- Create a new class, place the old field and its behavior in the class, and store the object of the class in the original class

#### Replace Array with Object
Criteria:
- You have an array that contains multiple types of data
Action:
- Replace the array with an object that will have separate fields for each element

#### Change Unidirectional Association to Bidirectional
Criteria:
- You have two classes that each need to use the features of the other, but the association between them is only unidirectional
Action:
- Add the missing association

#### Change Bidirectional Association to Unidirectional
Criteria:
- You have a bidirectional association between classes, but one of the classes doesn't use the other's features
Action:
- Remove the unused association

#### Encapsulate Field
Criteria:
- You have a public field
Action:
- Make the field private and create access methods

#### Encapsulate Collection
Criteria:
- A class contains a Collection field and a simple getter and setter for working with the collection
Action:
- Make the getter-returned value read-only and create methods for adding/deleting elements of the collection

#### Replace Magic Number with Symbolic Constant
Criteria:
-
Action:
-

#### Replace Type Code with Class
Criteria:
- You have Type Code, such as symbolic constants representing key strings or magic numbers
Action:
- Create a new class and use its objects instead of the type code values

#### Replace Type Code with Subclasses
Criteria:
- You have Type Code that directly affects program behavior through conditionals
Action:
- Create subclasses for each value of the type code.  Then extract the relevant behaviors from the original class to these subclasses.  Replace the control flow with polymorphism

#### Replace Type Code with State/Strategy
Criteria:
- You have Type Code that directly affects program behavior through conditionals, but you can't use subclasses to fix it
Action:
- Replace type code with a state object.

#### Replace Subclass with Fields
Criteria:
- You have subclasses differing only in their (constant-returning) methods.
Action:
- Replace the methods with fields in the parent class and delete the subclasses.

### Simplifying Conditional Expressions

#### Consolidate Conditional Expression
Criteria:
- You have multiple conditionals that lead to the same result or action
Action:
- Consolidate all these conditionals into a single expression

#### Consolidate Duplicate Conditional Fragments
Criteria:
- Identical code can be found in all branches of a conditional
Action:
- Move the code outside the conditional

#### Decompose Conditional
Criteria:
- You have a complex conditional
Action:
- Decompose the the complicated parts of the conditional into separate methods: the condition, then, and else

#### Replace Conditional with Polymorphism
Criteria:
- You have a conditional that performs various actions depending on object type or property
Action:
- Create subclasses matching the branches of the conditional.  In them, create a shared method and move code from the corresponding branch of the conditional to it.  Then replace the conditional with the relevant method call.  The result is that the proper implementation will be attained via polymorphism depending on the object class

#### Remove Control Flag
Criteria:
- You have a boolean variable that acts as a control flag for multiple boolean expressions
Action:
- Use break, continue, and return instead

#### Replace Nested Conditional with Guard Clauses
Criteria:
- You have a group of nested conditionals and it's hard to determine the normal flow of code execution.
Action:
- Isolate all special checks and edge cases into separate clauses and place them before the main checks.  Ideally, you should have a flat list of conditional,s one after the other

#### Introduce Null Object
Criteria:
- Since some methods return null instead of real objects, you have checks for null
Action:
- Instead of returning null, return a null object that exhibits default behavior

#### Introduce Assertion
Criteria:
- For a portion of code to work correctly, certain conditions or values must be true
Action:
- Replace these assumptions with explicit assertion checks

### Simplifying Method Calls
#### Add Parameter
Criteria:
- A method doesn't have enough data to perform certain actions
Action:
- Create a new parameter to pass the necessary data

#### Remove Parameter
Criteria:
- A parameter isn't used in the body of a method
Action:
- Remove the unused parameter

#### Rename Method
Criteria:
- The name of a method doesn't explain what the method does
Action:
- Rename the method to something self-explanatory

#### Separate Query from Modifier
Criteria:
- A method both returns a value and changes an object
Action:
- Split the method into two parts

#### Parameterize Method
Criteria:
- Multiple methods perform similar actions that are different only in their internal values or operations
Action:
- Combine these methods by using a parameter that will pass the necessary value

#### Introduce Parameter Object
Criteria:
- Your methods contain a repeating group of parameters
Action:
- Replace these parameters with an object containing the parameters

#### Preserve Whole Object
Criteria:
- You get several values from an object and then pass them as parameters to a method
Action:
- Pass the whole object to the method and let it get what it needs

#### Remove Setting Method
Criteria:
- the value of a field should be set only when it's created, and not change at any time after that
Action:
- Remove methods that set the field's value

#### Replace Parameter with Explicit Methods
Criteria:
- A method is split into two parts, each of which is run depending on the value of a parameter
Action:
- Extract the individual parts of the method into their own methods and call them instead of the original method

#### Replace Parameter with Method Call
Criteria:
- Calling a query method and passing its results as the parameters of another method, while that method could call the query directly
Action:
- Instead of passing the value through a parameter, try placing the query call inside the method body

#### Hide Method
Criteria:
- A method isn't used by other classes or is used only inside its own class hierarchy
Action:
- Make the method private or protected

#### Replace Constructor with Factory Method
Criteria:
- You have a complex constructor that does something more than just setting parameter values in object fields
Action:
- Create a factory method and use it to replace constructor calls

#### Replace Error Code with Exception
Criteria:
- A method returns a value that represents an error
Action:
- Throw an exception instead

#### Replace Exception with Test
Criteria:
- Throwing an exception where you could just test instead
Action:
- Replace the exception with a condition test

### Dealing with Generalization
#### Pull Up Field
Criteria:
- Two classes have the same field
Action:
- Move the field to the superclass

#### Pull Up Method
Criteria:
- Two subclasses have methods that perform similar work
Action:
- Make the methods identical and them move them to the superclass

#### Pull Up Constructor Body
Criteria:
- Subclasses have constructors that are very similar
Action:
- Create a superclass constructor and move the code that's the same in the subclasses there, and call the superclass constructor in the subclasses

#### Push Down Field
Criteria:
- a field on a superclass is only used by a few subclasses
Action:
- Move the field to these subclasses

#### Push Down Method
Criteria:
-
Action:
-

#### Extract Subclass
Criteria:
- A class has features that are used only in certain cases
Action:
- Create a subclass and use it in these cases

#### Extract Superclass
Criteria:
- You have two classes with common fields and methods
Action:
- Create a shared superclass and move all identical fields and methods to it

#### Extract Interface
Criteria:
- Multiple clients are using the same part of a class interface, or part of the interface in two classes are the same
Action:
- Move this identical portion to its own interface

#### Collapse Hierarchy
Criteria:
- You have a class hieracrchy in which a subclass is practically the same as its superclass
Action:
- Merge the subclass and superclass

#### Form Template Method
Criteria:
- Your subclasses implement algorithms that contain similar steps in the same order
Action:
- Move the algorithm structure and identical steps to the superclass and leave implementation of the different steps in the subclasses

#### Replace Inheritance with Delegation
Criteria:
- You have a subclass that uses only a portion of the methods of its superclass (or it's not possible to inherit superclass data)
Action:
- Create a field and put a superclass object in it, delegate methods to the superclass object, and get rid of inheritance

#### Replace Delegation with Inheritance
Criteria:
- A class contains many simple methods tthat delegate to all methods of another class
Action:
- Make the class a dlegate inheritor, which makes the delgating methods unnecessary
