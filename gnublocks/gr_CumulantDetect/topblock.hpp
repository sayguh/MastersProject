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


#include <cmath>
#include <stdint.h>

#include <cmath>

#include <gr_top_block.h>
#include <osmosdr_source_c.h>
#include <gr_stream_to_vector.h>
#include "gr_file_source.h"
#include "cumulant_sink.hpp"
#include <string>

class TopBlock : public gr_top_block
{
	public:
	TopBlock(double centerFreq, double sampleRate, int numPoints, std::string fileName) :
			gr_top_block("Top Block"),
						/*vector_length(sample_rate/fft_width),*/  // This doesn't make any sense to me, the vectorLength should just be the given fftWidth
						vector_length(numPoints),
						source(osmosdr_make_source_c()), /* OsmoSDR Source */
						stv(gr_make_stream_to_vector(sizeof(float)*2, vector_length)), /* Stream to vector */
						/* Sink - this does most of the interesting work */
						sink(make_cumulant_sink(source, vector_length, fileName))
		{

			/* Set up the OsmoSDR Source */
			source->set_sample_rate(sampleRate);
			source->set_center_freq(centerFreq);
			source->set_freq_corr(0.0);
			source->set_gain_mode(false);
			source->set_gain(30);
			source->set_if_gain(25.0);
			printf("Debug 1\n");
			/* Set up the connections */
			connect(source, 0, stv, 0);
			printf("Debug 2\n");
			connect(stv, 0, sink, 0);
			printf("Debug 3\n");
		}
		
	private:
		size_t vector_length;

		osmosdr_source_c_sptr source;
		gr_stream_to_vector_sptr stv;
		cumulant_sink_sptr sink;
};
