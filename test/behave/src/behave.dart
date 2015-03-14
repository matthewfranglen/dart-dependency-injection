part of dependency_injection.test.behave;

// given("foo")
//   .when("bar")
//     .then("baz")
//       .test()
//
// given, when, and then create lambdas that is finally executed by the test().
// Given, when, and then are implemented three classes, allowing and to return the current class:
//
// given("foo").and("faz")
//   .when("bar").and("war")
//     .then("baz").and("waz")
//       .test()
//
// The step implementations are annotated. They are loaded using the scenario:
//
// scenario("testing foo bar baz", steps: TestSteps)
//   .given("foo").and("faz")
//     .when("bar").and("war")
//       .then("baz").and("waz")
//         .test()


// vim: set ai et sw=2 syntax=dart :
