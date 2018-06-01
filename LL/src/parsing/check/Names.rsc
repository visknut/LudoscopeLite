//////////////////////////////////////////////////////////////////////////////
//
// Check Property Names
// @brief        This file contains the functions to check if a propety name
//							 refers to the right data structure in the project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         28-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::check::Names

import errors::Parsing;
import parsing::DataStructures;
import sanr::language::AST;
import parsing::languages::alphabet::AST;

data Name
 = tileName()
 | ruleName()
 | moduleName()
 | undefinedName();

public TransformationArtifact checkPropertyNames
(
	TransformationArtifact artifact
)
{
	for (Property property <- artifact.project.specification.properties)
	{
		visit (property)
		{
			case tileSet(str tileName, FilterNow filterNow, FilterWhere filterWhere) :
			{
				artifact = checkTileName(artifact, tileName, property@location);
			}
			case nowAdjacent(str tileName) :
			{
				artifact = checkTileName(artifact, tileName, property@location);
			}
			case everRule(str ruleName) :
			{
				artifact = checkRuleName(artifact, ruleName, property@location);
			}
		}
	}
	return artifact;
}

private TransformationArtifact checkTileName
(
	TransformationArtifact artifact,
	str tileName,
	loc propertyLocation
)
{
	Name name = findName(artifact, tileName);
	switch(name)
	{
		case undefinedName() :
		{
			artifact.errors = [propertyName(tileName, propertyLocation)];
		}
		case ruleName() :
		{
			artifact.errors = [nameType("tile", "rule", propertyLocation)];
		}
		case moduleName() :
		{
			artifact.errors = [nameType("tile", "module", propertyLocation)];
		}
	}
	return artifact;
}

private TransformationArtifact checkRuleName
(
	TransformationArtifact artifact,
	str ruleName,
	loc propertyLocation
)
{
	Name name = findName(artifact, ruleName);
	switch(name)
	{
		case undefinedName() :
		{
			artifact.errors = [propertyName(ruleName, propertyLocation)];
		}
		case tileName() :
		{
			artifact.errors = [nameType("rule", "tile", propertyLocation)];
		}
		case moduleName() :
		{
			artifact.errors = [nameType("rule", "module", propertyLocation)];
		}
	}
	return artifact;
}

public Name findName
(
	TransformationArtifact artifact,
	str name
)
{
	visit(artifact)
	{
		case symbol(str symbolName, str color, str fill, str abbreviation, str shape) :
		{
			if (symbolName == name)
			{
				return tileName();
			}
		}
		case ludoscopeModule(str moduleName,
		list[str] inputs,
		str alphabetName,
		TileMap startingState, 
		RuleMap rules, 
		Recipe recipe) :
		{
			if (name in rules)
			{
				return ruleName();
			}
			if (moduleName == name)
			{
				return moduleName();
			}
		}
	}
	return undefinedName();
}