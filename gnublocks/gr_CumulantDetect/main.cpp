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


#include <cstdio>

#include "arguments.hpp"
#include "topblock.hpp"

void printRunParams(double centerFreq, double sampleRate, int fftWidth, double freqRes, double cycFreqRes, std::string fileName);

int main(int argc, char **argv)
{
	Arguments arguments(argc, argv);
//	printRunParams(arguments.getCenterFreq(), arguments.getSampleRate(), 0, arguments.getFreqRes(), arguments.getCyclicFreqRes(), arguments.getFileName());
	TopBlock top_block(
		arguments.getCenterFreq(),
		arguments.getSampleRate(),
		arguments.getNumPoints(),
		arguments.getFileName());
	top_block.run();
	return 0; //actually, we never get here because of the rude way in which we end the scan
}

//void printRunParams(double centerFreq, double sampleRate, int fftWidth, double freqRes, double cycFreqRes, std::string fileName)
//{
//
//	printf("Center Frequency: \t%f\n", centerFreq);
//	printf("Sample Rate: \t%f\n", sampleRate);
//	printf("FFT Width: \t%i\n", fftWidth);
//	printf("Frequency Resolution: \t%f\n", freqRes);
//	printf("Cyclic freq res: \t%f\n", cycFreqRes);
//	printf("File Name: \t%s\n", fileName.c_str());
//	int Np(pow2roundup((unsigned int)sampleRate/freqRes));
//	printf("Np: \t%i\n", Np);
//	unsigned int L(Np/4);
//	printf("L: \t%i\n", L);
//	unsigned int P(pow2roundup(sampleRate/cycFreqRes/L));
//	printf("P: \t%i\n", P);
//	unsigned int N(P*L);
//	printf("Vector length: \t%i\n", N);
//
//}
