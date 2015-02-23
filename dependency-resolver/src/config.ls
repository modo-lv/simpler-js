module?.exports = class Config
	instance:
		/**
		* Instance creation lifetime scope.
		*/
		type: "lifetime"


	resolve:
		withRequire: false


	(@obj) ->
		@instance =
			type: "lifetime"

		@resolve =
			withRequire: false

		@beforeInit = ->


	/**
	* Configure dependency to create a new instance on every resolve() request.
	*/
	instancePerDependency: ~> @instance.type = "dependency"; @


	/**
	* Configure dependency to create and re-use a single instance in the DependencyResolver object scope.
	*/
	instancePerLifetime: ~> @instance.type = "lifetime"; @


	/**
	* Do not create an instance. Meant for functions, objects already are instances so they default to lifetime scope.
	*/
	noInstance: ~> @instance.type = "none"; @


	/**
	* Define a method to call before calling init function
 	*/
	beforeInit: ->