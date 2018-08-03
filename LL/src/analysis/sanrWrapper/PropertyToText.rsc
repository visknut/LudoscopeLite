module analysis::sanrWrapper::PropertyToText

import sanr::language::AST;

public str propertyToText(Property property)
{
	str condition = "";
	str tile = "";
	str filterNow = "";
	str filterWhere = "";
	
	visit(property) {
		case exact(int size): condition = "<size>x ";
		case atLeast(int size): condition = "at least <size>x ";
		case atMost(int size): condition = "at most <size>x ";
		case tileSet(str tileName, FilterNow filterNow, FilterWhere filterWhere): tile = tileName;
		case nowAdjacent(str tileName): filterNow = " adjacent to <tileName>";
		case everRule(str ruleName): filterWhere = " in <ruleName>";
	};
	
	return condition + tile + filterNow + filterWhere;
}