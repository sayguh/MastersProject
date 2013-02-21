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

#include <gr_top_block.h>
#include <osmosdr_source_c.h>
#include <gr_stream_to_vector.h>
#include <gr_fft_vcc_fftw.h>
#include <gr_complex_to_xxx.h>
#include <gr_single_pole_iir_filter_ff.h>
#include <gr_nlog10_ff.h>
#include "autofam_sink.hpp"
#include <string>

class TopBlock : public gr_top_block
{
	public:
		TopBlock(double centerFreq, double sampleRate, int fftWidth, double freqRes, double cycFreqRes, std::string fileName) :
			gr_top_block("Top Block"),
			vector_length(fftWidth),
			window(GetWindow(vector_length)),
			source(osmosdr_make_source_c()), /* OsmoSDR Source */
			stv(gr_make_stream_to_vector(sizeof(float)*2, vector_length)), /* Stream to vector */
			fft(gr_make_fft_vcc_fftw(vector_length, true, window, false, 1)),
			/* autoFam - this does most of the interesting work */
			sink(make_autofam_sink(source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName))
		{

			printRunParams(centerFreq, sampleRate, fftWidth, freqRes, cycFreqRes, fileName);

			/* Set up the OsmoSDR Source */
			source->set_sample_rate(sampleRate);
			source->set_center_freq(centerFreq);
			source->set_freq_corr(0.0);
			source->set_gain_mode(false);
			source->set_gain(30);
			source->set_if_gain(25.0);
			
			/* Set up the connections */
			connect(source, 0, stv, 0);
			connect(stv, 0, fft, 0);
			connect(fft, 0, sink, 0);
		}
		
	private:
		/* http://en.wikipedia.org/w/index.php?title=Window_function&oldid=508445914 */
		std::vector<float> GetWindow(size_t n)
		{
			std::vector<float> w;
			w.resize(n);

			double a = 0.16;
			double a0 = (1.0 - a)/2.0;
			double a1 = 0.5;
			double a2 = a/2.0;

			for (unsigned int i = 0; i < n; i++){
				w[i] = a0 - a1 * cos((2.0 * 3.14159 * (double)i)/(double)(n - 1)) + a2 * cos((4.0 * 3.14159 * (double)i)/(double)(n - 1));
			}
			return w;
		}

		double GetWindowPower()
		{
			double total = 0.0;
			std::vector<float>::iterator it = window.begin();
			for (it = window.begin(); it != window.end(); it++) {
				total += (*it) * (*it);
			}
			return total;
		}

		void printRunParams(double centerFreq, double sampleRate, int fftWidth, double freqRes, double cycFreqRes, std::string fileName)
		{
			printf("Center Frequency: \t%f\n", centerFreq);
			printf("Sample Rate: \t%f\n", sampleRate);
			printf("FFT Width: \t%i\n", fftWidth);
			printf("Frequency Resolution: \t%f\n", freqRes);
			printf("Cyclic freq res: \t%f\n", cycFreqRes);
			printf("File Name: \t%s\n", fileName.c_str());
		}

		size_t vector_length;
		std::vector<float> window;

		osmosdr_source_c_sptr source;
		gr_stream_to_vector_sptr stv;
		gr_fft_vcc_sptr fft;
		gr_complex_to_mag_squared_sptr ctf;
		gr_single_pole_iir_filter_ff_sptr iir;
		gr_nlog10_ff_sptr lg;
		autofam_sink_sptr sink;
};
