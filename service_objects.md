#### Definition of a Service

A stateless action?

Enough With Service Objects Already: https://avdi.codes/service-objects/

#### What should be a Service and what shouldn't? Should I create single-responsibility objects that perform business logic, or procedural service objects? When do I build one or the other?

- An object that handles business logic but doesn't have a well-defined business **domain role**
- Objects tend to grow and accumulate more responsibilities. As Corey Haines puts it, objects are attractors for functionality. And once they mature, objects with **confused, ill-defined roles** can be some of the hardest to refactor.
- And this is my larger concern about the proliferation of service objects handling business rules: you can end up with a whole basket full of Service Objects, many with implicit data dependencies between them, representing business workflows that have no explicit representation.
- Most services should be infrastructure services, such as “send an email”. Business domain services should be rare
- Domain-level services (e.g. a “transfer funds” service in a banking app) should be named with terminology which is part of a domain's “ubiquitous language”.
- Walk through various steps, grabbing objects from various places, and performing a sequence of actions on those objects. There's a name for this kind of code: a procedure. Or, in the terminology of Martin Fowler's Patterns of Enterprise Application Architecture, a transaction script.


Yes, you can easily say:

Step 1: Achieve perfect separation of concerns.

Step 2: Profit!

My entire point in writing this article is that in many cases, step 1 is not only out of immediate reach, devoting time to it may actually be waste. And in that case, hiding a procedure behind the fig leaf of a “service object” that doesn’t represent any kind of real concept in the business domain does more harm than good.

The (article) example shows code that’s in a state which is, realistically, only testable at an acceptance or integration-level of test. That’s the point: a lot of code out there is at this level of organization.

Several comments have had an implied context of: “well, [if you first refactor everything to have perfect separation of concerns, which is totally an ideal use of your time, then] using a Service Object will buy you some marginal testability convenience!”. Which, OK, sure. But taking the code as it is and just adding the Service Object part (without any of that other refactoring) actually makes the eventual refactoring (if it ever becomes necessary) harder rather than easier. In my experience.


## Managing Dependencies (Other Services / Objects)

Call them privately and independently

Create a private method that will return a memoized version of the injected dependency. Here is an example:

```
#services/thing_service.rb

class ThingService

  def initialize(param1)
    @param1 = param1
  end

  def call
    result = other_service.call
    private_method(result)
  end  private

  attr_reader :param1  def other_service
    @other_service ||= OtherService.new(param1)
  end
end
```
