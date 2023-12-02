//===========================================================================
//
// Jass Syntax test
// https://jass.sourceforge.net/doc/ (partially outdated)
// https://github.com/lep/pjass/ (syntax checker, up to date)

// type system and game API native function definitions

type customWidget extends widget

constant native GetRescuer takes nothing returns unit // hello

native ForForce takes force whichForce, code callback returns nothing

native Rect takes real minx, real miny, real maxx, real maxy returns rect

// Common.ai native. There's no empty group to give it a distinct color
native GetAiPlayer takes nothing returns integer

// it's a legit comment! told you so
// and this is import too.

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************

globals
	// User-defined
	sound udg_soundHandle = null
	string noinit
	unit array uArray
	constant integer ten = 10
	constant boolean itstrue = true
	boolean itsfalse = false

	// Generated
	trigger gg_trg_StartSound1 = null

	// Duplicating constants from blizzard.j for syntax highlighting
	constant real bj_PI = 3.14159
endglobals

function InitGlobals takes nothing returns nothing
	// integers must be defined at the beginning of a function
	local integer i
	local integer x = 2
	local real pi = 3.14
	set udg_soundHandle = null
endfunction


function Default_Melee_Init takes nothing returns nothing
	call MeleeStartingVisibility(  )
	call MeleeStartingHeroLimit(  )
	call MeleeGrantHeroItems(  )
	call MeleeStartingResources(  )
	call MeleeClearExcessUnits(  )
	call MeleeStartingUnits(  )
endfunction

function someTrigger_callback takes nothing returns nothing
	call DisplayTextToForce( GetPlayersAll(), "someTrigger_callback fired." )
endfunction

function RandomStuff takes nothing returns nothing
	local trigger someTrigger = CreateTrigger()
	local sound snd = CreateSound("Sound\\Interface\\ClanInvitation.wav", false, false, false, 10, 10, null)
	call StartSound( snd )
	// KillWhenDone to avoid leaks

	call DisplayTextToForce( GetPlayersAll(), "TRIGSTR_005" )
	call DisplayTextToForce( GetPlayersAll(), "Back\\Slash" )
	call DisplayTextToForce( GetPlayersAll(), "MultilineString:
-")



    call TriggerAddAction( someTrigger, function someTrigger_callback )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )
	call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), true )
	call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), false )

	set uArray[3] = CreateUnit(Player(0), 'hfoo', -200, 123, 90)
	set noinit = "it's now initialized"
endfunction

function iteration takes nothing returns nothing
	local integer i = 0
	loop
		call DisplayTimedTextToPlayer(Player(i),0,0,60, "Hello player")
		set i = i + 1
		exitwhen i == bj_MAX_PLAYERS
	endloop
endfunction

function conditionals takes nothing returns nothing
	if 3 == 4-1 then
		call DoNothing() // NOP function
	endif

	if 2*2 == 0 then
		call DoNothing()
	elseif 1*2 == 3 then
		// We could do nothing again
	else
		call DoNothing()
	endif

	return
endfunction

function expressions takes nothing returns boolean
	local integer plus     = 1 + 1
	local integer minus    = 1 - 1
	local integer multiply = 3 * 3
	local integer divide = 20 / 4
	local integer precedence = 4 + 2 * 3 - 60 / 6

	local real tau = 3.14 * 2

	local boolean equals         = 4 == 4
	local boolean notEquals     = 4 != 4
	local boolean greaterEquals = 4 >= 4
	local boolean lessEquals    = 4 <= 4
	local boolean greaterThan   = 4 > 4
	local boolean lessThan       = 4 < 4

	local boolean boolAnd = true and true
	local boolean boolOr = false or true
	local boolean boolNot = not true

	local string s = "hello, " + "world!"
	local boolean parentheses = ( (2 == 2) and 1 == 1 ) and true or false

	local integer ascii_code = 'd' // 100
	// This is made into a 32-bit integer:
	// Pseudocode: (97 << 24 + 98 << 16 + 99 << 8 + 100)
	// Note that JASS2 does not support bitwise operators
	local integer fourCC_code = 'abcd'

	// leading or trailing underscore _ not allowed
	local integer identifierA123
	local integer hex = $a
	local integer hex2 = $123c
	local integer hex3 = 0x123
	local integer octal = 0777

	return true
endfunction

function debugmode takes nothing returns nothing
	// debug-statements are only evaluated if the game was started
	// in debug mode
	debug call DisplayTimedTextToPlayer(Player(0),0,0,60, "It's a debug message")
	debug set noinit = "debug mode is enabled"
	debug if true then
		call DisplayTimedTextToPlayer(Player(0),0,0,60, "debugged if statement: true")
	else
		call DisplayTimedTextToPlayer(Player(0),0,0,60, "debugged if statement: false")
	endif

	debug loop

		call DisplayTimedTextToPlayer(Player(0),0,0,60, "debugged loop")
		exitwhen true
	endloop
endfunction

function receivesCallback takes code someFunc returns nothing
	// it is not allowed to directly call a "code" variable in Jass
	call DoNothing()
endfunction

function passAFunction takes nothing returns nothing
	call receivesCallback(function debugmode)
endfunction

