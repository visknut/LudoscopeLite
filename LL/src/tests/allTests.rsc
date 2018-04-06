module tests::allTests

import tests::parsing::grammar;
import tests::parsing::alphabet;
import tests::parsing::recipe;
import tests::parsing::project;

public test bool runAllParsingTests()
{
	return tests::parsing::grammar::runAllTests()
	|| tests::parsing::alphabet::runAllTests()
	|| tests::parsing::recipe::runAllTests()
	|| tests::parsing::project::runAllTests();
}