# Practical Object-Oriented Design in Ruby, by Sandi Metz

## Chapter 1: A Brief Introduction to Object-Oriented Programming

### What is OO software?
>OO software views the world a series of spontaneous interactions between objects
>Object-oriented applications are made up of objects and the messages that pass between them.

>Object-Oriented design is about managing dependencies. It is a set of coding techniques that arrange dependencies such that objects can tolerate change. In the absence of design, unmanaged dependencies wreak havoc because objects know too much about one another.

It's instructive to think about Object-Oriented languages relative to non-Object-Oriented languages, otherwise known as Procedural Languages.

#### Procedural Languages:
- data and behaviour are separate
- can create simple scripts
- can define variables (make up names and associate those with bits of data) and access data by referring to the variables
- know about a small, fixed set of different kinds of data-types like strings, numbers, arrays, files etc
- contain built-in operations that do reasonable things to the various data types, eg: concatenate strings or read files
- your expectations about which operations you can use are based on your knowledge of a variable's data-type
- a variable may only have one data-type, therefore understanding this type lets you know what operations are valid
- can create functions by grouping predefined operations together under a new name
- can define complex data structures by assembling predefined data types into a named arrangement
- every possible data-type and operation are already exist and are built into the language
- __cannot__ make up new operations
- __cannot__ make up new data types

>In a procedural language there is a chasm between data and behaviour. Data is one thing, behaviour is something completely different. Data gets packaged up into variables and then passed around to behaviour, which could, frankly, do anything to it. Data is like a child that behaviour sends off to school every morning; there is no way of knowing what actually happens while it is out of sight. The influences on data can be unpredictable and largely untraceable.

#### Object-Oriented Languages:
- data and behaviour are combined into a single thing: Objects
- Objects *replace* data-types
- Objects have behaviour 
- Objects may contain data which they alone can access
- Objects invoke one another's behaviour by sending each other messages
- an Object's behaviour is built into the Object itself rather than the syntax of the language
- an Object's behaviour (methods) and attributes (definitions of variables) are defined by its or it parent's class
- classes provide a blueprint for replicating copies (instances) of an Object that all inherit the type of that parent class
- instances of an Object will inherit the same behaviour (send and respond to the same messages) and attribute names from their parent class
- instances of an Object may have different values assigned to their attributes, and therefore represent different unique representations of the same class
- Objects will always inherit the type of their parent class, but may also have additional types
- understanding an Object's type(s) lets you understand it's behaviour (which messages it will respond to and how it will respond)
- Object classes themselves are instances of the `Class` class, which manufactures new classes

>Because string objects supply their own operations, Ruby doesn't have to know anything in particular about the string data type; it need only provide a general way for objects to send messages. For example, if strings understand the *concat* message, Ruby doesn't have to contain syntax to concatenate strings, it just has to provide a way for one object to send *concat* to another.

>Once the `String` class exists it can be used to repeately *instantiate*, or create, new *instances* of a string object. Every newly instantiated `String` *implements* the same methods and uses the same attribute names but each contains its own personal data. They share the same methods so they all behave like `Strings`; they contain different data so they represent different ones.

> The `String` class, that is, the blueprint for new string objects, *is itself an object*; it's an instance of the `Class` class. Just as every string object is a data-specific instance of the `String` class, every class object (`String`, `Fixnum` etc) is a data-specific instance of the `Class` class.

### On the difficulty and cost of change, and the importance of practical design
>Part of the difficulty of design is that every problem has two components. You must not only write code for the feature you plan to deliver today, you must also create code that is amenable to being changed later. For any period of time that extends past the initial delivery of the beta, the cost of change will eventually eclipse the original cost of the application.
>Designs that anticipate specific future requirements almost always end badly. Practical design does not anticipate what will happen to your application, it merely accepts that something will and that, in the present, you cannot know what ... The purpose of design is to allow you to design *later* and its primary goal is to reduce the cost of change.

### Judging and measuring design & technical debt
>Bad OOD metrics are indisputibly a sign of bad design; code that scores poorly *will* be hard to change. Unfortunately, good scores don't prove the opposite, that is, they don't guarantee that the next change you make will be easy or cheap. The problem is that it is possible to create beautiful designs that over-anticipate the future. While these designs may generate very good OOD metrics, if they anticipate the *wrong* future they will be expensive to fix when the real future finally arrives. OOD metirics cannot identify designs that do the wrong thing in the right way.

>The ultimate software metric would be *cost per feature over the time interval that matters*.

>Sometimes the value of having the feature right now is so great that it outweighs any future increase in costs. If lack of a feature will force you out of business today it doesn't matter how much it will cost to deal with the code tomorrow; you must do the best you can in the time you have. Making this kind of design compromise is known as taking on *technical debt*. This is a loan that will eventually need to be repaid, quite likely with interest.

>Because your goal is to write software with the lowest cost per feature, your decision about how much design to do depends on two things: your skills and your timeframe... If design takes half of your time this morning, pays that time back this afternoon, and then continues to provide benefits for the lifetime of the application, you get a kind of daily compounding interest on your time; this design effort pays off forever.

### Design patterns
>The notion of design patterns is incredibly powerful. To name common problems and to solve the problems in common ways brings the fuzzy into focus. Design Patterns gave an entire generation of programers the means to communicate and collaborate... Patterns have a place in every designer's toolbox... Pattern misapplication results in complicated and confusing code but this result is not the fault of the pattern itself. A tool cannot be faulted for its use, the user must master the tool.

Therefore Design Patterns are the tools in the developer's toolkit, and Design is the application of those tools as a solution to a particular problem.

>Design is thus an art, the art of arranging code.

### Why design fails
- __Lack of Design__: It is possible to produce working applications with no understanding of design, particularly with approachable languages like Ruby. However they are typically brittle and don't allow for later changes, eventually rendering them unmanageable. "I can't add that because it will break everything"
- __Overdesign__: Programmers with some experience may know OO Design techniques but are not experienced in implementing them. These programmers see patterns where none exist and create complicated designs that become unmanageable because due to a lack of flexibility. "It wasn't designed for that"
- __Lack of Feedback__: "Design is a process of progressive discovery that relies on a feedback loop. This feedback loop should be timely and incremental... The iterative nature of Agile development allows design to adjust regularly and to evolve naturally."

### Agile
>Agile believes that the most cost-effective way to produce what customers really want is to collaborate with them, building software one small bit at a time such that each delivered bit has the opportunity to alter ideas about the next. The Agile experience is that this collaboration produces software that differs from what was initially imagined; the resulting software could not have been anticipated by any other means ... Agile works because it acknowledges that certainty is unattainable *in advance* of the appliciation's existence.

>However, just because Agile says "don't do a big up front design (BUFD)" doesn't mean it tells you to do no design at all. The word *design* when used in BUFD has a different meaning that when used in OOD. BUFD is about completely specifying and totally documenting the anticipated future inner workings of all the features of the proposed application... OOD is concerned with a much narrower domain. It is about arranging what code you have so that it will be easy to change... Agile processes *guarantee* change and your ability to make these changes depends on your application's design. If you cannot write well-designed code you'll have to rewrite your application during every iteration. Agile thus does not prohibit design, it requires it.

