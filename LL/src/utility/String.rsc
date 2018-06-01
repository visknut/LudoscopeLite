module utility::String

import String;

public str removeQuotes(str string)
{
	return string[1..-1];
}

public str cleanGrammarName(str name)
{
	return removeQuotes(name[6..]);
}

public str cleanContainerName(str name)
{
	return name[3..];
}

public str cleanAlphabetName(str name)
{
	return removeQuotes(name[10..]);
}

public str cleanRecipeBool(str text)
{
	return text[8..];
}

public loc fileLocation(loc projectLocation, str filename, str extension)
{
	return projectLocation.parent + (filename + extension);
}

public str fileName(loc file)
{
	int extensionLength = size(file.extension);
	str fileName = file.file;
	int lengthOfDot = 1;
	int endFileName = size(fileName) - extensionLength - lengthOfDot;
	return fileName[0 .. endFileName];
}