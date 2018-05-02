module util::Time

import DateTime;

public Duration addDuration(Duration sum, Duration addition)
{
	sum.years += addition.years;
	sum.months += addition.months;
	sum.days += addition.days;
	sum.hours += addition.hours;
	sum.minutes += addition.minutes;
	sum.seconds += addition.seconds;
	sum.milliseconds += addition.milliseconds;
	return sum;
}

public str durationToString(Duration time)
{
	return "<time.minutes>m<time.seconds>s<time.milliseconds>ms";
}

public int durationToMilliseconds(Duration time)
{
	return time.milliseconds + (time.seconds * 1000) + (time.minutes * 60000);
}

public Duration flattenDuration(Duration duration)
{
	duration.seconds += duration.milliseconds / 1000;
	duration.milliseconds = duration.milliseconds % 1000;
	
	duration.minutes += duration.seconds / 60;
	duration.seconds = duration.seconds % 60;
	
	duration.hours += duration.minutes / 60;
	duration.minutes = duration.minutes % 60;
	
	duration.days += duration.hours / 24;
	duration.hours = duration.hours % 24;
	return duration;
}