module utility::Integer

public int sign(int number)
{
	if (number > 1)
	{
		return 1;
	}
	else if (number < 1)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}