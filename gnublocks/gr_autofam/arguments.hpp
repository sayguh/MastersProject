/*
	gr-autofam - A GNU Radio spectral auto-correlation density function
	Youssef Bagoulla

	Created this code by starting with a skeleton of gr_scan which I'm
	using to help with gnu-radio input syntax.  The algorithms have been
	taken from the matlab script AUTOFAM.
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

#include <stdlib.h>
#include <argp.h>
#include <string>

class Arguments
{
	public:
		Arguments(int argc, char **argv) :
			centerFreq(88.5),
			sampleRate(2),
			freqRes(100),
			cyclicFreqRes(10),
			fileName("outputFile.txt")
		{
			argp_parse (&argp_i, argc, argv, 0, 0, this);
		}
		
		double getCenterFreq()
		{
			return centerFreq * 1000000.0;
		}

		double getSampleRate()
		{
			return sampleRate * 1000000.0;
		}

		double getFreqRes()
		{
			return freqRes * 1000.0;
		}

		double getCyclicFreqRes()
		{
			return cyclicFreqRes * 1000.0;
		}

		std::string getFileName()
		{
			return fileName;
		}
		
	private:
		static error_t s_parse_opt(int key, char *arg, struct argp_state *state)
		{
			Arguments *arguments = (Arguments *)state->input;
			return arguments->parse_opt (key, arg, state);
		}
		
		error_t parse_opt (int key, char *arg, struct argp_state *state)
		{
			switch (key)
			{
				case 'f':
					centerFreq = atof(arg);
					break;
				case 'r':
					sampleRate = atof(arg);
					break;
				case 't':
					freqRes = atof(arg);
					break;
				case 'c':
					cyclicFreqRes = atof(arg);
					break;
				case 'n':
					fileName = arg;
					break;
				default:
					return ARGP_ERR_UNKNOWN;
			}
			return 0;
		}
		
		static argp_option options[];
		static argp argp_i;
		
		double centerFreq;
		double sampleRate;
		double freqRes;
		double cyclicFreqRes;
		std::string fileName;
};
argp_option Arguments::options[] = {
	{"center-frequency", 'f', "FREQ", 0, "Frequency in MHz [87kHz]"},
	{"sample-rate", 'r', "RATE", 0, "Samplerate in Msamples/s [2,000ksps]"},
	{"freq-res", 't', "FRES", 0, "Desired Frequency Resolution in kHz [10kHz]"},
	{"cycfreq-res", 'c', "CYCRES", 0, "Desired Cyclic Frequency Resolution in kHz [100kHz]"},
	{"file-name", 'n', "FILE", 0, "File name for output data to be written to [outputFile.txt]"},
	{0}
};
argp Arguments::argp_i = {options, s_parse_opt, 0, 0};

const char *argp_program_bug_address = "sayguh@gmail.com";
const char *argp_program_version =  "v0";
