... <- describe "DependencyResolution"

it "should call init method when using create()", !->
	dr = new Dr <<< initMethodName: "init"

	spy = sinon.spy!

	class Test
		-> @init = spy

	dr.register "Test", Test .instancePerDependency!

	for from 1 to 3
		dr.prepare "Test" .create!

	expect spy.callCount .to .equal 3