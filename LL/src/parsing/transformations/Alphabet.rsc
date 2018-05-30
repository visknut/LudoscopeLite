//////////////////////////////////////////////////////////////////////////////
//
// Transform Alphabet
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Alphabet

import parsing::languages::alphabet::AST;
import parsing::DataStructures;
import parsing::Parser;

alias AbstractAlphabet = parsing::languages::alphabet::AST::Alphabet;

public TransformationArtifact transformAplhabets(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str fileName <- syntaxTree.alphabets)
	{
		AbstractAlphabet abstractAlphabet = syntaxTree.alphabets[fileName];
		artifact.project.alphabets += (fileName : abstractAlphabet);
	}
	return artifact;
}
