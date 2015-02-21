class DependencyResolution
	/**
	* Owner DependencyResolver.
	*/
	dr: null

	/**
	* Object to resolve
	*/
	obj: null


	(@dr, @obj) ->
		@arguments = []


	addArguments: (...args) ~>
		@arguments ++= args
		return this


	resolve: ~>
		return @dr.resolve this


if module? then module.exports = DependencyResolution