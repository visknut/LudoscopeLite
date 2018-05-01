//////////////////////////////////////////////////////////////////////////////
//
// Tests for all functionality of LL
// @brief        This file contains both unit tests and integration tests for
//							 LudoscopeLight. They can all be run using ':test' in
//							 the console.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::AllTests

import tests::parsing::Grammar;
import tests::parsing::Alphabet;
import tests::parsing::Recipe;
import tests::parsing::Project;
import tests::parsing::Checking;
import tests::parsing::CompleteProjects;

import tests::execution::Matching;
import tests::execution::Instructions;
import tests::execution::Execution;

public test bool runAllParsingTests()
{
	return tests::parsing::Grammar::runAllTests()
	&& tests::parsing::Alphabet::runAllTests()
	&& tests::parsing::Recipe::runAllTests()
	&& tests::parsing::Project::runAllTests()
	&& tests::parsing::Checking::runAllTests()
	&& tests::parsing::CompleteProjects::runAllTests()
	&& tests::execution::Matching::runAllTests()
	&& tests::execution::Instructions::runAllTests()
	&& tests::execution::Execution::runAllTests();
}