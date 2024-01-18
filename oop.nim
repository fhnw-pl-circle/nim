type
    # an object must inherit from RootObj to enable inheritance
    Person* = ref object of RootObj
        name*: string
        age*: int
    Student* = ref object of Person # an no multiple inheritance
        id: int

var
    person: Person
    student: Student = Student(name: "max")

assert student of Student
assert person of Person
assert student of Person

echo repr(person)
echo repr(student)

# dynamic vs static dispatch
method sayHi(p: Person): void = echo "My name is ", p.name
method sayHi(s: Student): void = echo "Hi I am ", s.name

proc hi(p: Person): void = echo "My name is ", p.name
proc hi(s: Student): void = echo "Hi I am ", s.name

let
    alice = Person(name: "Alice")
    bob = Student(name: "Bob")
    max: Person = Student(name: "Max")

echo "methods..."
alice.sayHi()
bob.sayHi()
max.sayHi()
echo "procs..."
alice.hi()
bob.hi()
max.hi()