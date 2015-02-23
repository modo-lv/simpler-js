# simpler-js
Utility modules to add features, convenience and other utilities to JavaScript.


## Usage

The most common use for dependency injection is to have one instance shared across many objects. Here's an example how to achieve that with DR.

Create a "class" constructable function you want to register:

```JavaScript

var Klass = function(dr) {
  this.dr = dr;
  this.randomNumber = Math.random();
};

```

Notice the "dr" parameter on the constructor. Dependency resolver passes itself as the first argument to the constructor. This allows dependency chaining and universal DR access without polluting global (or any other) namespace.

Load the DR and register your new "class". By default, registrations are "instance-per-lifetime", meaning DR will create a new instance of the class when it is first resolved and then re-use it for every subsequent resolution.

```JavaSCript

var $dr = require("simplerjs-dependency-resolver");

$dr.register("MyClass", Klass);

```

First time time DR's ``resolve()`` method is called, it will create a new instance of the registered function, but every resolution request afterwards will return the same instance.

```JavaScript

var instance1 = $dr.resolve("MyClass");
var instance2 = $dr.resolve("MyClass");
var instance3 = $dr.resolve("MyClass");

instance1.randomNumber; // 0.13589457...
instance2.randomNumber; // 0.13589457...
instance3.randomNumber; // 0.13589457...

```