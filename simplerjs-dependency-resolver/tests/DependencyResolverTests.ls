require "./test-setup"

... <- describe "DependencyResolver"

it "registers a function and resolves an instance", ->
	dr = new Dr
	class Test
		-> @name = "TestInstance"

	dr.register Test .instance-per-dependency!

	instance = dr.resolve Test

	expect instance .to .have .property "name"
	expect instance.name .to .equal "TestInstance"


it "resolves function with custom parameters", ->
	class Test
		(@id, @name) ->
			@number = 12

	dr = new Dr

	dr.register Test .instancePerDependency!

	instance = dr.prepare Test .addArguments 1, "One" .resolve!

	expect instance .to .have .property "_dr"
	expect instance.id .to .equal 1
	expect instance.name .to .equal "One"
	expect instance.number .to .equal 12


it "handles register() calls with arrayed arguments", ->
	class Test1
	class Test2

	dr = new Dr

	dr.registerAll [Test1, Test2]

	instance = dr.resolve Test2

	expect instance .to .have .property "_dr"


it "correctly finds dependency keys", ->
	dr = new Dr

	expect dr._keyFor "Test1" .to .equal '"Test1"'
	expect dr._keyFor -> .to .be .a 'function'
	expect dr._keyFor a:1,b:2 .to .equal '{"a":1,"b":2}'


it "correctly handles resolve() with string key", ->
	dr = new Dr

	dr.register "Test", ->
	inst = dr.resolve "Test"

	expect inst .to .be .an 'object'
	expect inst .to .have .property '_dr'


it "correctly handles resolveAll() with string keys", ->
	dr = new Dr

	dr.registerAll [
		["Test", ->]
	]

	inst = dr.resolve "Test"

	expect inst .to .be .an 'object'
	expect inst .to .have .property "_dr"


it "handles lifetime instances", ->
	dr = new Dr

	func = -> @a = 50

	reg = dr.register func

	expect reg.instance.type .to .equal "lifetime"

	inst = dr.resolve func

	expect inst.a .to .equal 50


it "handles register() with provided keys", ->
	dr = new Dr
	dr.register "Test1", -> @.value = 1
	dr.registerAll [
		["Test2", -> @.value = 2]
		["Test3", -> @.value = 3]
	]

	instances = [
		dr.resolve "Test1"
		dr.resolve "Test2"
		dr.resolve "Test3"
	]

	expect instances.0.value .to .equal 1
	expect instances.1.value .to .equal 2
	expect instances.2.value .to .equal 3


it "throws correct error on missing key", ->
	dr = new Dr

	expect(-> dr.resolve "INotExist").to.Throw("Dependency not registered: \"INotExist\"")


it "handles resolveAll() without errors", ->
	dr = new Dr

	dr.registerAll [
		["Test1", -> @x = 12]
		["Test2", -> @x = 34]
	]

	result = dr.resolveAll ["Test1" "Test2"]

	expect result.0.x .to .equal 12
	expect result.1.x .to .equal 34