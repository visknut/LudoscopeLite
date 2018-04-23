module parsing::CreateSyntaxTree

import parsing::Parser;
import parsing::GatherFiles;
import IO;

public SyntaxTree parseCompleteProject(loc projectFile)
{
	SyntaxTree syntaxTree = syntaxTree([], (), (), (), []);
	
	syntaxTree = parseFile(projectFile, syntaxTree);
	
	list[loc] fileLocations = 
	 	gatherFileLocations(syntaxTree, projectFile);

	for (loc file <- fileLocations)
	{
		syntaxTree = parseFile(file, syntaxTree);
	}
	
	return syntaxTree;
}