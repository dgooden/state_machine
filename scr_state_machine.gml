/// @function DTGSM_State()
/// @desc state for state machine
function DTGSM_State() constructor 
{
	_userData = {};
	
	///@function setUserData(data)
	///@param struct to be saved as userData
	///@desc saves data as userData
	static setUserData = function(data) 
	{
		_userData = {};
		var keys = variable_struct_get_names(data);
		for ( var i=0; i<array_length(keys); i++ ) {
			var key = keys[i];
			variable_struct_set(_userData,key,variable_struct_get(data,key));
		}
	}
	
	///@function getUserData
	///@desc returns userData struct
	static getUserData = function()
	{
		return _userData;
	}
	
	///@function clearUserData
	///@desc clears the userData struct
	static clearUserData = function()
	{
		delete _userData;
		_userData = {};
	}
	
	///@function onEnter()
	///@desc function called when state is first entered
	static onEnter = function() {}
	
	///@function onExit()
	///@desc function called when state is exiting
	static onExit  = function() {}
	
	///@function onDraw()
	///@desc function called during draw event
	static onDraw  = function() {}
	
	///@function onStep()
	///@desc function called during step event
	static onStep  = function() {}
}

/// @function DTGSM_StateMachine()
/// @desc state machine
function DTGSM_StateMachine() constructor 
{
	_curState = -1;
	_curName = "";
	_timeSince = 0;
	_framesSince = 0;
	_states = {};

	_timeStart = 0;
	
	
	/// @function add(stateName,state)
	/// @param stateName The name of the state to add
	/// @param state The DTGSM_State() struct to add
	static add = function(stateName, state) 
	{
		if ( ! variable_struct_exists(_states,stateName) ) {
			variable_struct_set(_states,stateName,state);
		}
	}
	
	/// @function remove(stateName)
	/// @param stateName The name of the state to remove
	static remove = function (stateName) 
	{
		if ( variable_struct_exists(_states,stateName) ) {
			variable_struct_remove(_states,stateName);
		}
	}
	
	/// @function update(stateName,state)
	/// @param stateName The name of the state to update
	/// @param state The DTGSM_State() struct to add
	static update = function(stateName,state) 
	{
		variable_struct_set(_states,stateName,state);
	}
	
	/// @function getName
	/// @desc returns the name of current state 
	static getName = function()
	{
		return _curName;
	}
	
	/// @function get(stateName)
	/// @param stateName name of the state
	/// @desc returns the DTGGM_State() struct stored under stateName
	static get = function(stateName)
	{
		return variable_struct_get(_states,stateName);
	}
	
	/// @function goto(stateName)
	/// @param stateName name of the state
	/// @desc  goes to a new state specified by stateName
	static goto = function(stateName) {
		var newState = variable_struct_get(_states,stateName);
		if ( _curState != -1 ) {
			_curState.onExit();
		}
		_curState = newState;
		_curName = stateName;
		_timeSince = 0;
		_framesSince = 0;
		_timeStart = get_timer();
		_curState.onEnter();
	}
	
	/// @function getFrames()
	/// @desc returns the number of frames that have passed since we 
	//        entered this state
	static getFrames = function()
	{
		return _framesSince;	
	}
	
	/// @function getTime()
	/// @desc returns the number of microseconds that have passed since 
	///       we entered this state
	static getTime = function()
	{
		_timeSince = (get_timer() - _timeStart);
		return _timeSince;
	}
	
	/// @function getTimeInSeconds()
	/// @desc returns the number of seconds that has passsed since we
	///       entered this state
	static getTimeInSeconds = function()
	{
		_timeSince = (get_timer() - _timeStart);
		return (_timeSince/1000000);
	}
	
	/// @function getUserData()
	/// @desc returns the user data for the current state
	static getUserData = function()
	{
		return _curState.getUserData();
	}
	
	/// @function setUserData(data)
	/// @param data The user data to set
	/// @desc sets the current state user data
	static setUserData = function(data)
	{
		_curState.setUserData(data);
	}
	
	/// @function clearUserData()
	/// @desc clears the current state user data
	static clearUserData = function(data)
	{
		_curState.clearUserData();
	}
	
	/// @function empty()
	/// @desc removes all states, leaving an empty state machine
	static empty = function()
	{
		delete _states;
		_states = {};
		_curState = -1;
		_curName = "";
		_timeSince = 0;
		_framesSince = 0;
	}
	
	/// @function step()
	/// @desc call this every step function (if needed)
	///       required if you want to use framesSince
	static step = function()
	{
		++_framesSince;
		_curState.onStep();
	}
	
	/// @function draw()
	/// @desc call this every draw function (if needed)
	static draw = function()
	{
		_curState.onDraw();
	}	
}