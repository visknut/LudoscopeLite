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
import analysis::madWrapper::MADFramework;
import analysis::madWrapper::DataTransformation;
import analysis::madWrapper::SymbolHierarchy;

import parsing::DataStructures;
import execution::DataStructures;
import util::mad::Metric;

public bool runAllTests()
{
	return  extractSymbolHierarchy()
	&& symbolHierarchyTransformation()
	&& madRuleScoreMapTransformation()
	&& ludoscopeRuleTransformation()
	&& MADFramework();
}

public test bool extractSymbolHierarchy()
{
	/* Arrange */
 	Rule rule1 = rule(reflections(false,false,false),[[1]],[[[2]]]);
 	Rule rule2 = rule(reflections(false,false,false),[[2]],[[[3]]]);
 	Rule rule3 = rule(reflections(false,false,false),[[3]],[[[1]]]);
	LudoscopeModule module1 = ludoscopeModule(1, [], "", [[1]], (1 : rule1), []);
	LudoscopeModule module2 = ludoscopeModule(2, [1], "", [[]], (2 : rule2), []);
	LudoscopeModule module3 = ludoscopeModule(3, [2], "", [[]], (3 : rule3), []);
	ModuleHierarchy moduleHierarchy = [{module1},{module2},{module3}];
	SymbolHierarchy expectedResult = [{1},{2},{3}];
	
	/* Act */
	SymbolHierarchy result = extractSymbolHierarchy(moduleHierarchy);
	
	/* Assert */
	return expectedResult == result;
}

private test bool symbolHierarchyTransformation()
{
	/* Arrange */
	SymbolHierarchy symbolHierarchy = [{1},{2,3},{4}];
  Detail expectedResult = {<"2","1">,
													 <"3","1">,
    											 <"4","1">,
													 <"4","2">,
												   <"4","3">};

	/* Act */
  Detail result = symbolHierarchyToDetail(symbolHierarchy);
	
	/* Assert */
	return expectedResult == result;
}

private test bool madRuleScoreMapTransformation()
{
	/* Arrange */
	list[MadRuleScoreMap] madRuleScores = [<2, [<"1", "1", 0>, <"1", "2", 1>, <"1", "0", -1>, <"1", "1", 0>]>];
 	list[RightHandScore] expectedResult = [<0, [[0, 1], [-1, 0]]>];
  
	/* Act */
 	result = madRuleScoreMapToRightHandScores(madRuleScores);
	
	/* Assert */
	return expectedResult == result;
}

private test bool ludoscopeRuleTransformation()
{
	/* Arrange */
  Rule ludoscopeRule = rule(reflections(false,false,false), [[0,0], [0,0]], [[[1,1], [1,1]], [[2,2], [2,2]]]);
	list[MadRuleMap] expectedResult = [<2,[<"0","1">,<"0","1">,<"0","1">,<"0","1">]>,
																		 <2,[<"0","2">,<"0","2">,<"0","2">, <"0","2">]>];

	/* Act */
 	list[MadRuleMap] result = ludoscopeRuleToMadRuleMaps(ludoscopeRule);
	
	/* Assert */
  return expectedResult == result;
}

private test bool MADFramework()
{
	/* Arrange */
	Rule rule1 = rule(reflections(false,false,false),[[1]],[[[2]]]);
	Rule rule2 = rule(reflections(false,false,false),[[2]],[[[3]]]);
	Rule rule3 = rule(reflections(false,false,false),[[3]],[[[1]]]);
	LudoscopeModule module1 = ludoscopeModule(1, [], "", [[1]], (1 : rule1), []);
	LudoscopeModule module2 = ludoscopeModule(2, [1], "", [[]], (2 : rule2), []);
	LudoscopeModule module3 = ludoscopeModule(3, [2], "", [[]], (3 : rule3), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3], (), [], [], []);
	
	ProjectScore expectedResult = (1:(1:[<1,[[1]]>]),
																 2:(2:[<1,[[1]]>]),
						  									 3:(3:[<-1,[[-1]]>]));
						  									 
	/* Act */
	ProjectScore result = calculateMAD(project);

	/* Assert */
	return expectedResult == result;
}