module util::string

public str removeQuotes(str string) {
	return string[1..-1];
}