//////////////////////////////////////////////////////////////////////////////
//
// Testing module for the Metric of Added Detail
// @brief        This file contains test functions for extracting the symbol
//							 hierarchy and calculating the MAD score for a project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::metrics::MAD

import IO;
import metrics::MAD;
import metrics::SymbolHierarchy;
import parsing::DataStructures;
import execution::DataStructures;

public bool runAllTests()
{
	return  testSymbolHierarchy();
}

private test bool testSymbolHierarchy()
{
	/* Arrange */
 	Rule rule1 = rule(reflections(false,false,false),[[1]],[[[2]]]);
 	Rule rule2 = rule(reflections(false,false,false),[[2]],[[[3]]]);
 	Rule rule3 = rule(reflections(false,false,false),[[3]],[[[1]]]);
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[1]], ("rule1" : rule1), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module1"], "", [[]], ("rule2" : rule2), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module2"], "", [[]], ("rule3" : rule3), []);
	ModuleHierarchy moduleHierarchy = [{module1},{module2},{module3}];
	SymbolHierarchy expectedResult = [{1},{2},{3}];
	
	/* Act */
	SymbolHierarchy result = extractSymbolHierarchy(moduleHierarchy);
	
	/* Assert */
	return expectedResult == result;
}

//private test bool calculateMADScore()
//{
//	/* Arrange */
//	
//	/* Act */
//	
//	/* Assert */
//}