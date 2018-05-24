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
import tests::parsing::Properties;

import tests::execution::Matching;
import tests::execution::Instructions;
import tests::execution::ModuleHierarchy;

import tests::metrics::MAD;

public bool runAllTests()
{
	return tests::parsing::Grammar::runAllTests()
	&& tests::parsing::Alphabet::runAllTests()
	&& tests::parsing::Recipe::runAllTests()
	&& tests::parsing::Project::runAllTests()
	&& tests::parsing::Checking::runAllTests()
	&& tests::parsing::CompleteProjects::runAllTests()
	&& tests::execution::Matching::runAllTests()
	&& tests::execution::Instructions::runAllTests()
	&& tests::execution::ModuleHierarchy::runAllTests()
	&& tests::metrics::MAD::runAllTests()
	&& tests::parsing::Properties::runAllTests();
}

private test bool grammarTests()
{
	return tests::parsing::Grammar::runAllTests();
}

private test bool alphabetTests()
{
	return tests::parsing::Alphabet::runAllTests();
}

private test bool recipeTests()
{
	return  tests::parsing::Recipe::runAllTests();
}

private test bool projectTests()
{
	return tests::parsing::Project::runAllTests();
}

private test bool checkingTests()
{
	return tests::parsing::Checking::runAllTests();
}

private test bool completeProjectTests()
{
	return tests::parsing::CompleteProjects::runAllTests();
}

private test bool matchingTests()
{
	return tests::execution::Matching::runAllTests();
}

private test bool instructionsTests()
{
	return tests::execution::Instructions::runAllTests();
}

private test bool moduleHierarchyTests()
{
	return tests::execution::ModuleHierarchy::runAllTests();
}

private test bool metricsTests()
{
	return tests::metrics::MAD::runAllTests();
}

private test bool propertiesTests()
{
	return tests::parsing::Properties::runAllTests();
}