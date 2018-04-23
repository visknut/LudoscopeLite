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
	| extension(loc fileLocation);
	
str errorToString(parsing(loc fileLocation))
{
	return "Parsing Error:
		\n File: <fileLocation.path>
		\n Line: <fileLocation.begin.line>";
}

str errorToString(ambiguity(loc fileLocation, str usedSyntax))
{
	return "Parsing Error: ambiguity found while parsing.
		\n Syntax: <usedSyntax>
		\n File: <fileLocation.path>
		\n Line: <fileLocation.begin.line>";
}

str errorToString(imploding(loc location))
{
	return "Parsing Error: could not implode the parsing tree to
		the AST.
		\n File: <location.path>";
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