//////////////////////////////////////////////////////////////////////////////
//
// Parsing errors
// @brief        This file contains data types for parsing errors.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module errors::Parsing

data ParsingError
	= imploding(loc fileLocation)
	| version(str version)
	| fileNotFound(loc fileLocation)
	| parsing(loc fileLocation)
	| ambiguity(loc fileLocation, str usedSyntax)
	| extension(loc fileLocation)
	| mapType(str mapType, loc fileLocation)
	| mapSize(int size, int symbols, loc fileLocation)
	| rightAndLeftHandSize(int leftWidth, int leftHeight, 
		int rightWidth, int rightHeight, loc fileLocation);
	
str errorToString(parsing(loc fileLocation))
{
	return "Parsing error:
		File: <fileLocation.path>
		Line: <fileLocation.begin.line>";
}

str errorToString(ambiguity(loc fileLocation, str usedSyntax))
{
	return "Parsing error: ambiguity found while parsing.
		Syntax: <usedSyntax>
		File: <fileLocation.path>
		Line: <fileLocation.begin.line>";
}

str errorToString(imploding(loc location))
{
	return "Parsing error: could not implode the parsing tree to
		the AST.
		File: <location.path>";
}

str errorToString(version(str version))
{
	return "Version error: LL was build for version 0.6f of Ludoscope.
		 Version of input: <version>";
}

str errorToString(fileNotFound(loc fileLocation))
{
	return "Input error: could not find the following file: 
		<fileLocation.path>";
}

str errorToString(extension(loc fileLocation))
{
		return "Input error: could not parse <fileLocation>, because 
			the extension \".<fileLocation.extension>\" is not supported by LL.";
}

str errorToString(mapType(str mapType, loc fileLocation))
{
	return "Type error: \'<mapType>\' maps are not supported by LL
		File: <fileLocation.path>
		Line: <fileLocation.begin.line>";
}

str errorToString(mapSize(int size, int symbols, loc fileLocation))
{
	return "Error: the declared size of the map (<size>) does not match with
		the amount of symbols that follow (<symbols>).
		File: <fileLocation.path>
		Line: <fileLocation.begin.line>";
}

str errorToString(rightAndLeftHandSize(int leftWidth, int leftHeight, 
		int rightWidth, int rightHeight, loc fileLocation))
{
	return "Error: the dimensions of the left hand (<leftWidth>, <leftHeight>) 
	do not match with	the dimensions of the right hand (<rightWidth>, <rightHeight>).
		File: <fileLocation.path>
		Line: <fileLocation.begin.line>";
}