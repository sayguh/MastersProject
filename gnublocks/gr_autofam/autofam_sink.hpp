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

#include <ctime>
#include <set>
#include <utility>
#include <iostream>
#include <fstream>
#include <sstream>
#include <iostream>
#include "HelperFunctions.hpp"
#include <cmath>

#include <boost/shared_ptr.hpp>

#include <string>
#include <gr_block.h>
#include <gr_io_signature.h>
#include <osmosdr_source_c.h>

class autofam_sink : public gr_block
{
	// source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName)
	public:
		autofam_sink(osmosdr_source_c_sptr source, unsigned int vector_length, double centerFreq, double sampleRate, double freqRes, double cycFreqRes, std::string fileName) :
			gr_block ("autofam_sink",
				gr_make_io_signature (1, 1, sizeof (float) * vector_length),
				gr_make_io_signature (0, 0, 0)),
			m_source(source), //We need the source in order to be able to control it
			m_fs(sampleRate),
			m_df(freqRes),
			m_dalpha(cycFreqRes),
			m_vector_length(vector_length), //size of the FFT
		    m_fileName(fileName)
		{
			ZeroBuffer();
			filestr.open (m_fileName.c_str(), std::fstream::in | std::fstream::out | std::fstream::app);

		}

		virtual ~autofam_sink()
		{
			delete []m_buffer; //delete the buffer
		}
		
	private:
		virtual int general_work(int noutput_items, gr_vector_int &ninput_items, gr_vector_const_void_star &input_items, gr_vector_void_star &output_items)
		{

			for (int i = 0; i < ninput_items[0]; i++){
				ProcessVector(((float *)input_items[0]) + i * m_vector_length);
			}

			consume_each(ninput_items[0]);
			return 0;
		}
		
		void ProcessVector(float *input)
		{
			// TODO: This needs to be moved earlier into topblock b/c it determines the FFT size.
			int Np = pow(2,pow2roundup((int)m_fs/m_df));
			int L=Np/4;

			int P = pow(2, pow2roundup(m_fs/m_dalpha/L));

			int N=P*L;


		}
		
		/**
		 * fftshift equivalent
		 */
		void Rearrange(float *bands, double *freqs, double centre, double bandwidth)
		{
			double samplewidth = bandwidth/(double)m_vector_length;
			for (unsigned int i = 0; i < m_vector_length; i++){
				/* FFT is arranged starting at 0 Hz at the start, rather than in the middle */
				if (i < m_vector_length/2){ //lower half of the fft
					bands[i + m_vector_length/2] = m_buffer[i];
				}
				else { //upper half of the fft
					bands[i - m_vector_length/2] = m_buffer[i];
				}

				freqs[i] = centre + i * samplewidth - bandwidth/2; //calculate the frequency of this sample
			}
		}
		
		
		void ZeroBuffer()
		{
			/* writes zeros to m_buffer */
			for (unsigned int i = 0; i < m_vector_length; i++){
				m_buffer[i] = 0.0;
			}
		}
		
		// Our osmo source
		osmosdr_source_c_sptr m_source;

		// Not sure if I'll use
		float *m_buffer;
		unsigned int m_vector_length;

		double m_centerFreq;
		double m_fs; // sample rate
		double m_df; // desired frequency resolution
		double m_dalpha; // desired cyclic frequency resolution

		// Used for writing output to file
		std::string m_fileName;
		std::fstream filestr;

		//unsigned int vector_length, double centerFreq, double sampleRate, double freqRes, double cycFreqRes, std::string fileName
};

/* Shared pointer thing gnuradio is fond of */
typedef boost::shared_ptr<autofam_sink> autofam_sink_sptr;
autofam_sink_sptr make_autofam_sink(osmosdr_source_c_sptr source, unsigned int vector_length, double centerFreq, double sampleRate, double freqRes, double cycFreqRes, std::string fileName)
{
	return boost::shared_ptr<autofam_sink>(new autofam_sink(source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName));
}
