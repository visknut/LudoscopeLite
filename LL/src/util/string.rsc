module util::string

public str removeQuotes(str string)
{
	return string[1..-1];
}

public str cleanModuleName(str name)
{
	return removeQuotes(name[6..]);
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