//////////////////////////////////////////////////////////////////////////////
//
// Check maps
// @brief        Functions that check for three different errors in maps.
//							 - Check if the map type is supported.
//							 - Check if the map size matches the number of symbols.
//							 - Check if the dimensions of the left hand match
//                 the dimensions of the right hands.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::check::Maps

import parsing::languages::grammar::AST;

import List;
import parsing::Parser;
import errors::Parsing;

alias AbstractGrammar = parsing::languages::grammar::AST::Grammar;

public SyntaxTree checkMapTypes(SyntaxTree syntaxTree)
{
	for (str grammarName <- syntaxTree.grammars)
	{
		visit(syntaxTree.grammars[grammarName])
		{
			case MapType abstractMap: 
			{
				switch(abstractMap)
				{
					case string() : syntaxTree.errors += 
						[mapType("string", abstractMap@location)];
					case graph() : syntaxTree.errors += 
						[mapType("graph", abstractMap@location)];
					case shape() : syntaxTree.errors += 
						[mapType("shape", abstractMap@location)];
				}
			}
		}
	}
	return syntaxTree;
}

public SyntaxTree checkMapSize(SyntaxTree syntaxTree)
{
	for (str grammarName <- syntaxTree.grammars)
	{
		visit(syntaxTree.grammars[grammarName])
		{
			case expression(MapType mapType, list[Symbol] symbols) : 
			{
				if (mapType.width * mapType.height != size(symbols))
				{
					syntaxTree.errors += [mapSize(mapType.width * mapType.height, 
						size(symbols), mapType@location)];
				}
			}
			case leftHandExpression(MapType mapType, list[LeftHandSymbol] symbols) :
			{
				if (mapType.width * mapType.height != size(symbols))
				{
					syntaxTree.errors += [mapSize(mapType.width * mapType.height, 
						size(symbols), mapType@location)];
				}
			}
		}
	}
	return syntaxTree;
}

public SyntaxTree compareLeftAndRightHandSize(SyntaxTree syntaxTree)
{
	for (str grammarName <- syntaxTree.grammars)
	{
		visit(syntaxTree.grammars[grammarName])
		{
			case rule(str name, list[RuleSetting] settings, LeftHandExpression leftHand, 
				list[RightHandExpression] rightHands) : 
			{
				MapType leftHandMap = leftHand.mapType;
				for (RightHandExpression rightHand <- rightHands)
				{
					MapType rightHandMap = rightHand.expression.mapType;
					if (rightHandMap !:= leftHandMap)
					{
						syntaxTree.errors += [rightAndLeftHandSize(leftHandMap.width, 
							leftHandMap.height, 
							rightHandMap.width, 
							rightHandMap.height, 
							rightHandMap@location)];
					}
				}
			}
		}
	}
	return syntaxTree;
}