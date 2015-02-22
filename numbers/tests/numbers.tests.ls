it "round() correctly handles precision", ->
	testData = [
		# input, precision, result
		[1.234, 2, 1.23]
		[1.567, 2, 1.57]
		[9.999, 0, 10]
		[3.72856, 4, 3.7286]
	]

	for test in testData
		expect num.round test.0, test.1 .to .equal test.2


/**
* Checks that the random() function is actually inclusive
* and properly returns minimum / maximum values when the
* underlying Math.random() returns its minimum / maximum.
*/
it "random() reaches minimum and maximum value", ->
	testData = [
		[0, 10, 3]
		[1, 500, 2]
		[2, 2000, 4]
	]

	stub = sinon.stub Math, "random", -> fakeRandom

	fakeRandom = 0.999999999

	for test in testData
		expect num.random test.0, test.1, test.2 .to .equal test.1

	fakeRandom = 0

	for test in testData
		expect num.random test.0, test.1, test.2 .to .equal test.0

	stub.restore!