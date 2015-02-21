require "./test-setup"

... <- describe "DependencyResolver"

it "registers a function and resolves an instance", ->
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


it "handles register() calls with arrayed parameters", ->
	class Test1
	class Test2

	dr = new Dr

	dr.register [Test1, Test2]

	instance = dr.resolve Test2

	expect instance .to .have .property "_dr"