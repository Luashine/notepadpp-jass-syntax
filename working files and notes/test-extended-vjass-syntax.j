// Welcome, only vJass syntax extensions here.
// https://wc3modding.info/pages/vjass-documentation/

//! import "scriptfile"

// no more import

// Generates data as code based on definitions from an SLK file
//! loaddata "path.slk"

// This is a WC3 Reforged extension to support Lua code within Jass blocks
// The code within is supposed to be Lua

// It is also possible to hack the Jass2Lua thing by starting with
// endusercode and ending with beginusercode, then the code inside would be
// Jass that'll be transpiled by WorldEdit to Lua
//! beginusercode

-- the highlighting is not supposed to work correctly here.
function luafunc()

end

//! endusercode

// Includes files' contents
//! import vjass "filename_vj"
//! import zinc "filename_z"
//! import comment "filename_c"

// Turn off/on the vJass preprocessor
//! novjass

// plain jass inside
function something takes nothing returns nothing
	if true then
		DoNothing()
	endif
endfunction
//! endnovjass

// injects a piece of code into functions main or config:
//! inject main/config

//  code here will be injected
call Ghostbusters()

//! endinject


// external tool:
//! external EXTERNAL_TOOL_NAME [external arguments]

// external tool block:
//! externalblock EXTERNALNAME ARGUMENTS LIST
//! i These lines will get send to
//! i The tool as stdin
//! i The i and the space after the i are ignored.
  
     //comment and whitespace not to appear in stdin

//! i
//! i That one up there was just an empty line to send to the program
//! endexternalblock

// example:
//! externalblock extension=lua OBJECTMERGER SOME_ARGUMENTS $FILENAME$ OTHER_ARGUMENTS

//! endexternalblock


// libraries
library B
    function Bfun takes nothing returns nothing
		DoNothing()
    endfunction
endlibrary

// library_once is ignored if already defined
library_once B
    function Bfun takes nothing returns nothing
		DoNothing()
    endfunction
endlibrary

// Another snippet:

library C requires A, B, D
	function Cfun takes nothing returns nothing
		call Afun()
		call Bfun()
		call Dfun()
	endfunction
endlibrary

library D
	function Dfun takes nothing returns nothing
	endfunction
endlibrary

library B requires A
	function Bfun takes nothing returns nothing
		call Afun()
	endfunction
endlibrary

library A
	function Afun takes nothing returns nothing
	endfunction
endlibrary

// library requires

library A initializer InitA requires B

	function InitA takes nothing returns nothing
	   call StoreInteger(B_gamecache , "a_rect" , Rect(-100.0 , 100.0 , -100.0 , 100  ) )
	endfunction

endlibrary

library B initializer InitB
	globals
		gamecache B_gamecache
	endglobals

	function InitB takes nothing returns nothing
		set B_gamecache=InitGameCache("B")
	endfunction
endlibrary

// library optional requires, static

library OptionalCode requires optional UnitKiller
	globals
		constant boolean DO_KILL_LIB = true
	endglobals

	function fun takes nothing returns nothing
		local unit u = GetTriggerUnit()
		static if DO_KILL_LIB and LIBRARY_UnitKiller then
			call UnitKiller(u)
		else
			call KillUnit(u)
		endif
	endfunction

endlibrary

library UnitKiller

	function UnitKiller takes unit u returns nothing
		call BJDebugMsg("Unit kill!")
		call KillUnit(u)
	endfunction

endfunction

// private members, function

library privatetest
    globals
        private integer N=0
    endglobals
    private function x takes nothing returns nothing
        set N=N+1
    endfunction

    function privatetest takes nothing returns nothing
        call x()
        call x()
    endfunction
endlibrary

// public members, function

library cookiesystem
	public function ko takes nothing returns nothing
		call BJDebugMsg("a")
	endfunction

	function thisisnotpublicnorprivate takes nothing returns nothing
		 call ko()
		 call cookiesystem_ko() //cookiesystem_ prefix is optional
	endfunction
endlibrary

function outside takes nothing returns nothing
	 call cookiesystem_ko() //cookiesystem_ prefix is required
endfunction


// scopes

scope GetUnitDebugStr

    private function H2I takes handle h returns integer
        return h
        return 0
    endfunction

    function GetUnitDebugStr takes unit u returns string
        return GetUnitName(u)+"_"+I2S(H2I(u))
    endfunction
endscope

// nested scopes

library nestedtest
	scope A
	  globals
		private integer N=4
	  endglobals

	  public function display takes nothing returns nothing
		call BJDebugMsg(I2S(N))
	  endfunction
	endscope

	scope B
		globals
			public integer N=5
		endglobals

		public function display takes nothing returns nothing
			call BJDebugMsg(I2S(N))
		endfunction
	endscope

	function nestedDoTest takes nothing returns nothing
		call B_display()
		call A_display()
	endfunction

endlibrary

public function outside takes nothing returns nothing
	set nestedtest_B_N= -4
	call nestedDoTest()
	call nestedtest_A_display()

endfunction


// scope macros

scope test

    private function kol takes nothing returns nothing
        call BJDebugMsg("kol")
    endfunction
	 private function prv takes nothing returns nothing
        call BJDebugMsg("prv")
    endfunction

    function lala takes nothing returns nothing
         call ExecuteFunc(SCOPE_PRIVATE+"kol")
         call ExecuteFunc(SCOPE_PREFIX+"prv")
    endfunction

endscope


// keywords

scope myScope
	private keyword MyName
endscope


// Text macros

//! textmacro Increase takes TYPEWORD
function IncreaseStored$TYPEWORD$ takes gamecache g, string m, string l returns nothing
	call Store$TYPEWORD$(g,m,l,GetStored$TYPEWORD$(g,m,l)+1)
endfunction
//! endtextmacro

//! runtextmacro Increase("Integer")
//! runtextmacro Increase("Real")


// struct

struct pair
    integer x
    integer y
endstruct

function testpairs takes nothing returns nothing
	// struct .create syntax
 local pair A=pair.create()
    set A.x=5
    set A.x=8

    call BJDebugMsg(I2S(A.x)+" : "+I2S(A.y))

	// struct .destroy syntax
    call pair.destroy(A)

endfunction

// private/public structs
scope cool
    public struct myStructA
        integer x
    endstruct
	
    private struct hiddenStruct
        integer x
    endstruct

    globals
        myStructA x
        public myStructA otherStructB
    endglobals

endscope

// struct methods
struct point
	real x=0.0
	real y=0.0

	method move takes real tx, real ty returns nothing
		set this.x=tx
		set this.y=ty
	endmethod

endstruct

function testpoint takes nothing returns nothing
 local point p=point.create()
	call p.move(56,89)

	call BJDebugMsg(R2S(p.x))
endfunction

// static methods

struct encap
	real a=0.0
	private real b=0.0
	public real c=4.5

	private method dosomething takes nothing returns nothing
		if (this.a==5) then
			set this.a=56
		endif
	endmethod

	static method altcreate takes real a, real b, real c returns encap
	 local encap r=encap.create()
		set r.a=a
		set r.b=b
		set r.c=c
		// even though it is private you can use
		// it since we are inside the struct declaration
		call r.dosomething()				
	 return r
	endmethod

	method randomize takes nothing returns nothing
		// All legal:
		set this.a= GetRandomReal(0,45.0)
		set this.b= GetRandomReal(0,45.0)
		set this.c= GetRandomReal(0,45.0)
	endmethod

endstruct

// Since 0.9.Z.1 you may also override the destroy method by declaring
// your own one. Then use deallocate to call the normal destroy method.

struct syntheticExample
	real x
	
	private static method onInit takes nothing returns nothing
		// called during map init at a very early stage
	endmethod

	method onDestroy takes nothing returns nothing
		// when object is being destroyed
	endmethod
	
	method destroy takes nothing returns nothing
		this.deallocate()
	endmethod
	
	// .allocate()
	method callAllocateHere takes nothing returns nothing
		local otherStruct s = otherStruct.allocate()
	endmethod
endstruct


// interfaces

interface printable
	string someString
	method toString takes nothing returns string
endinterface

struct singleint extends printable
	integer v
	method toString takes nothing returns string
		if something then
			DoNothing()
		endif
		return I2S(this.v)
	endmethod
endstruct


// instances

interface A
    integer x
endinterface

struct B extends A
    integer y
endstruct

struct C extends A
    integer y
    integer z
endstruct

function test takes A inst returns nothing
   if (inst.getType()==C.typeid) then
     // We know for sure inst is actually an instance of type C
	 //notice the typecast operator
     set C(inst).z=5 
   endif
   if (inst.getType()==B.typeid) then
       call BJDebugMsg("It was of type B with value "+I2S( B(inst).y  ) )
   endif
endfunction


// override create
interface myinterface
    static method create takes nothing

    method qr takes unit u returns nothing
endinterface

struct st1 extends myinterface

	// it is only legal to return the current struct type
    static method create takes nothing returns st1
        return st1.allocate()
    endmethod

    method qr takes unit u returns nothing
        call KillUnit(u)
    endmethod
endstruct


// defaults creates a function returning a constant, if the function was not
// overriden

interface whattodo
    method onStrike takes real x, real y returns boolean defaults false
    method onBegin  takes real x, real y returns nothing defaults nothing

    method onFinish takes nothing returns nothing
endinterface

struct A extends whattodo //don't forget the extends...

    method onFinish takes nothing returns nothing //must be implemented
        //.. code
    endmethod

    // We are allowed to add onBegin, but not forced to
    method onBegin takes real x, real y returns nothing

        //.. code 
    endmethod

    // when somebody calls .onStrike on a whattodo of type A, it will return false
endstruct

struct B extends whattodo
    method onFinish takes nothing returns nothing //must be implemented
        //.. code
    endmethod

    // when somebody calls .onBegin on a whattodo of type A, it will do nothing
endstruct


// operator overloading
struct operatortest
	string str=""

	// get
	method operator [] takes integer i returns string
		return SubString(.str,i,i+1)
	endmethod
	// set
	method operator[]= takes integer i, string ch returns nothing
		set .str=SubString(.str,0,i)+ch+SubString(.str,i+1,StringLength(.str)-i)
	endmethod
	// mathematical comparison, only the syntax for "operator<" exists
	// because the other one is inferred
	method operator< takes  operatortest b returns boolean
		return StringLength(this.str) < StringLength(b.str)
	endmethod

	// other overloads include:
	
	// assign:
	// method operator x= takes integer v returns nothing
	
	// get value
	// method operator x takes nothing returns integer
endstruct


function test takes nothing returns nothing
 local operatortest x=operatortest.create()
 local operatortest y=operatortest.create()

	set x.str="Test..."
	set y.str=".Test"

	if (x<y) then
		call BJDebugMsg("Less than")
	endif
	if (x>y) then
		call BJDebugMsg("Greater than")
	endif
endfunction


// extending structs
struct A
   integer x
   integer y

   method setxy takes integer cx, integer cy returns nothing
       set this.x=cx
       set this.y=cy
   endmethod
endstruct

struct B extends A
   integer z
   method setxyz takes integer cx, integer cy, integer cz returns nothing
       call this.setxy(cx,cy) //we can use A's members
       set this.z=cz
   endmethod
endstruct

// another example with an interface:
interface myinterface
   method processunit takes unit u returns nothing
   method onAnEvent takes nothing returns boolean
endinterface

struct A extends myinterface

   method processunit takes unit u returns nothing
       call KillUnit(u)
   endmethod

   method onAnEvent takes nothing returns boolean
       return false
   endmethod
endstruct


// stub methods, super accessor
struct Parent

    stub method xx takes nothing returns nothing
        call BJDebugMsg("Parent")
    endmethod

    method doSomething takes nothing returns nothing
        call this.xx()
    endmethod

endstruct

struct ChildA extends Parent
    method xx takes nothing returns nothing
        call BJDebugMsg("- Child A -")
        call super.xx()
    endmethod
endstruct

struct ChildB extends Parent
    method xx takes nothing returns nothing
        call BJDebugMsg("- Child B --")
    endmethod
endstruct


// dynamic arrays
type intArray extends integer array[3]
type intArray_Array extends intArray array[3]


// private arrays in structs
struct stack
   private integer array V[100]
   private integer N=0

   method push takes integer i returns nothing
      set .V[.N]=i
      set .N=.N+1
   endmethod

   method empty takes nothing returns boolean
      return (.N==0)
   endmethod

   method full takes nothing returns boolean
      return (.N==.V.size)
   endmethod

endstruct


// delegates
struct B
	// its a keyword
    delegate A deleg

    static method create takes nothing returns B
     local B b = B.allocate()
        set B.deleg = A.create()
    endmethod

endstruct


// thistype special keyword
struct test 
    thistype array ts
    method tester takes nothing returns thistype
        return thistype.allocate()
    endmethod
endstruct


// modules
module MyRepeatModule

    method repeat1000 takes nothing returns nothing
     local integer i=0
        loop
            exitwhen i==1000
            call this.sub() //a method that is expected
                            //to exist in the struct
            set i=i+1
        endloop
    endmethod

endmodule

// implement
module MyModule
    implement MyOtherModule
    //since OptionalModule is not declared, next line is ignored
    implement optional OptionalModule

    static method swap takes thistype A , thistype B returns nothing
     local thistype C = thistype.allocate()
     //we are from the inside, so can use allocate, even though it is private

        call C.copy(A)
        call A.copy(B)
        call B.copy(C)
        call C.destroy()
    endmethod

endmodule

struct MyStruct
    integer a
    integer b
    integer c

    //code a copy method
    method copy takes MyStruct x returns nothing
        set this.a = x.a
        set this.b = x.b
        set this.c = x.c
    endmethod

    //get the swap method "for free"
    implement MyModule
    implement MyOtherModule //this module was already include by MyModule, so this line is ignored

endstruct


// execute and evaluate
function A takes real x returns real
 if(GetRandomInt(0,1)==0) then
 // keyword evaluate
    return B.evaluate(x*0.02)
 endif
 return x
endfunction

function B takes real x returns real
 if(GetRandomInt(0,1)==1) then
    return A(x*1000.)
 endif
 return x
endfunction

function DestroyEffectAfter takes effect fx, real t returns nothing
    call TriggerSleepAction(t)
    call DestroyEffect(fx)
endfunction

function test takes nothing returns nothing
 local unit u=GetTriggerUnit()
 local effect f=AddSpecialEffectTarget("Abilities\\Spells\\Undead\\Cripple\\CrippleTarget.mdl",u,"chest")
// keyword execute
  call DestroyEffectAfter.execute(f,3.0)

  set u=null
  set f=null
endfunction


// typecasting
interface  wack
    //... some declarations
endinterface

struct wek extends wack
   integer x
endstruct

function test takes wack W returns nothing
   //You are certain that W is of type wek, a way to cast the value is:
 local wek jo = W
   set jo.x= 5 //done

   // but sometimes creating a variable is too much work for the virtual machine and you
   // are only accessing it once 

   set wek(W).x=5 //also works.
endfunction


// .name field for functions to retrieve name
struct mystruct
    static method mymethod takes nothing returns nothing
        call BJDebugMsg("this works")
    endmethod
endstruct

function myfunction takes nothing returns nothing
    call ExecuteFunc(mystruct.mymethod.name) //ExecuteFunc compatibility

    call OnAbilityCast('A000',mystruct.mymethod.name)
    //for example, caster system's OnAbilityCast, requires a function name
endfunction


// .exists field
 interface myInterface
    method myMethod1 takes nothing returns nothing
    method myMethod2 takes nothing returns nothing
endinterface

struct myStruct
    method myMethod1 takes nothing returns nothing
        call BJDebugMsg("er")
    endmethod
endstruct

function test takes nothing returns nothing
 local myInterface mi = myStruct.create()
	// here
    if( mi.myMethod1.exists) then
        call BJDebugMsg("Yes")
    else
        call BJDebugMsg("No")
    endif

endfunction 


// array structs
struct playerdata extends array //syntax to declare an array struct
    integer a
    integer b
    integer c
endstruct

function init takes nothing returns nothing
 local playerdata pd

    set playerdata[3].a=12  //modifying player 3's fields.
    set playerdata[3].b=34  //notice it behaves as a global array
    set playerdata[3].c=500

    set pd=playerdata[4]
    set pd.a=17             //modifying player 4's fields.
    set pd.b=111            //yep, this is also valid
    set pd.c=501
endfunction


scope Tester initializer test
	// vJass keys (to be used as hashtable keys etc)
	globals
		// these are the keys
				 key AAAA
		private  key BBBB // yes it is just another type, so you can have
		public   key CCCC // public or private ones...

		constant key DDDD  //correctly describe it as a constant (not necessary)
	endglobals


    private function test takes nothing returns nothing
     local hashtable ht = InitHashtable()
        call SaveInteger(ht, AAAA, BBBB, 5)
        call SaveInteger(ht, AAAA, CCCC, 7)
        call SaveReal(ht, AAAA, DDDD, LoadInteger(ht,AAAA, BBBB) * 0.05 )
        call BJDebugMsg( R2S( LoadReal(ht,AAAA,DDDD) ) )

        call BJDebugMsg( I2S(BBBB) ) // will show two numbers, and
        call BJDebugMsg( I2S(CCCC) ) // the numbers will be different...
    endfunction

endscope


// arrays have .size
globals
    integer array myArray [500]
endglobals

function test takes nothing returns nothing
 local integer i=0

    call BJDebugMsg(I2S(myArray.size)) //prints 500

    loop
		// here
        exitwhen i>=myArray.size
        set myArray[i]=i
        set i=i+1
    endloop
endfunction


// 2D arrays have .width and .height (first and second array respectively)
globals
   integer array mat1 [10][20]

   constant integer W=100
   constant integer H=200
   integer array mat2 [W][H]

endglobals

function sumWidthHeight takes nothing returns integer
	return mat1.width * mat1.height
endfunction


// default instance limit applies (8192 for old WC3, see JASS_MAX_ARRAY_SIZE)
struct X
    integer a
    integer b
endstruct
// here you can have more
struct X[10000]
    integer a[2]
    integer b[5]
endstruct

struct X[10000] extends Y //bad
    integer a[2]
    integer b[5]
endstruct

interface A[20000] //good
    method a takes nothing returns nothing
endinterface

struct aBigOne extends array [ 20000]
   integer a
   integer b
   integer c
endstruct

function meh takes nothing returns nothing
   set aBigOne[19990].a = 12
endfunction


// Dynamic arrays with more index space
// size 200, so max 40 instances
type myDyArray extends integer array [200]
// size 200, max instances 200
type myDyArray extends integer array [200,40000]


// vJass colon operator (reverse notation for array[index])
function test takes nothing returns nothing
 local integer a=3
 local integer array X
//both of these statements do the same
    set X[a]=10 
    set a:X =10

    set X[a] = X[a] + 10
    set a:X = a:X +10 

endfunction

// Delimited comments
/* Delimited comments example
 They are a lot more useful than normal
 comments, really

*/
function test takes nothing returns nothing
    call Something( /*5*/ 66) /*We temporarily commented out 5, and replaced it with 66*/

    /*
    call Something( /*5*/ 66)
    */

    // That comment up there contains another delimited comment... /*
    call BJDebugMsg("Notice how the previous comment start was ignored" + /*
    */+"because it was inside a 'normal' comment "+/*
    */+"Also notice how we made the parser skipped the previous "+/*
    */+"line breaks because they were inside a comment"+/*
    */"These comments do not count if they are /*inside a string*/ ... ")


endfunction


// hook keyword
 function onRemoval takes unit u returns nothing
    call BJDebugMsg("unit is being removed!")
endfunction

struct err
    static method onrem takes unit u returns nothing 
       call BJDebugMsg("This also knows that a unit is being removed!")
    endmethod
endstruct

hook RemoveUnit onRemoval
hook RemoveUnit err.onrem //works as well


// This breaks inevitably, I give up
// function interfaces
function interface Arealfunction takes real x returns real

function double takes real x returns real
    return x*2.0
endfunction

function triple takes real x returns real
    return x*2.0
endfunction

function Test1 takes real x, Arealfunction F returns real
    return F.evaluate(F.evaluate(x)*F.evaluate(x))
endfunction

function Test2 takes nothing returns nothing
 local Arealfunction fun = Arealfunction.double //syntax to get pointer to function

   call BJDebugMsg( R2S(  Test1(1.2, fun) ))

   call BJDebugMsg( R2S(  Test1(1.2, Arealfunction.triple ) )) //also possible...
endfunction

// it continues counting this as a block

