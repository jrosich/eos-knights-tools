// Author: Ivan Kazmenko (gassa@mail.ru)
module prepare;
import std.algorithm;
import std.conv;
import std.format;
import std.json;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

int main (string [] args)
{
	auto ritem = File ("ritem.json").readln.parseJSON;
	if (args.length % 3 != 1)
	{
		writeln ("Usage: prepare [id1 lo1 hi1] [id2 lo2 hi2] [...]");
		return 1;
	}
	auto itemList = args.drop (1).map !(to !(int)).chunks (3).array;

	foreach (q; itemList)
	{
		auto code = q[0];
		auto ruleRange = ritem.array.find
		    !(x => x["code"].integer == code);
		if (ruleRange.empty)
		{
			writefln ("Error: item code %s not found", code);
			return 1;
		}
		if (!(0 <= q[1] && q[1] <= q[2] && q[2] <= 100))
		{
			writefln ("Error: lo = %s and hi = %s must satisfy " ~
			    "0 <= lo <= hi <= 100", q[1], q[2]);
			return 1;
		}
		auto rule = ruleRange.front;
		writefln ("%s %s %s %s %s %s %s %s %s", rule["code"],
		    rule["stat1"], rule["stat2"], rule["stat3"],
		    rule["stat1_rand_range"],
		    rule["stat2_rand_range"], rule["stat3_rand_range"],
		    rule["stat2_reveal_rate"], rule["stat3_reveal_rate"]);
		writefln ("%s %s", q[1], q[2]);
	}
	return 0;
}
