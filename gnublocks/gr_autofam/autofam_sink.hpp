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
#include <complex>
#include <Eigen/Dense>
#define _USE_MATH_DEFINES // for C++
#include <cmath>

#include <boost/shared_ptr.hpp>

#include <string>
#include <gr_block.h>
#include <gr_io_signature.h>
#include <osmosdr_source_c.h>

using Eigen::MatrixXcd;  // Using only complex double matrixes
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
			filestr.open (m_fileName.c_str(), std::fstream::in | std::fstream::out | std::fstream::app);

		}

		virtual ~autofam_sink()
		{
		}
		
	private:
		virtual int general_work(int noutput_items, gr_vector_int &ninput_items, gr_vector_const_void_star &input_items, gr_vector_void_star &output_items)
		{
			// Test data
			float testData[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
			m_fs = 100;
			m_df = 24;
			m_dalpha = 12;
			ProcessVector((&testData[0]));


			// The real data
//			for (int i = 0; i < ninput_items[0]; i++){
//				ProcessVector(((float *)input_items[0]) + i * m_vector_length);
//			}

			consume_each(ninput_items[0]);

			// Testing so exit after 1 iteration
			exit(-1);

			return 0;
		}
		
		void ProcessVector(float *input)
		{

			int Np(pow2roundup((int)m_fs/m_df));
			int L(Np/4);
			int P(pow2roundup(m_fs/m_dalpha/L));
			int N(P*L);
			int NN((P-1)*L + Np);

			// I should fix this, I don't need a complex matrix.
			MatrixXcd X(Np,P);
			for (int k = 0; k < P; k++)
			{
				for (int i = 0; i < Np; i++)
				{
					X(i, k) = input[k*L+1 + i];
				}
			}
//
//
//			double freqs[m_vector_length]; //for convenience
//			float XF1[m_vector_length];
//
//			// So bands0 is just the fftshift of the data, and freqs becomes the cooresponding frequencies.  So you could do plot(freqs, bands0)
//			fftShift(input, XF1, freqs, m_centerFreq, m_fs, m_vector_length); //organize the buffer into a convenient order (saves to bands0)
//
//			MatrixXcd E(Np,P);
//
//			/*****************
//			* Down conversion *
//			******************/
//			for (int k = -Np/2; k<Np/2-1; k++) {
//				for (int m = 0; m<P-1; m++) {
//					std::complex<double> x = (double)-2*M_PI*k*m*L/Np;
//					E(k+Np/2+1,m+1) = std::exp(x);
//				}
//			}
//
//			MatrixXcd XD(Np,P);
//
//			// I do the multiply and transpose at the same time here.
//			for (int i =0; i < Np; i++)
//			{
//				for (int j = 0; j < P; j++)
//				{
//					// Transpose XD
//					XD(j,i) = XF1(i,j) * E(i,j);
//				}
//			}
//
//			MatrixXcd XM(P,Np^2);  // Our zero matrix
//
//			for (int i = 0; i<P; i++)
//			{
//				for (int j = 0; j < Np^2; j++)
//				{
//					XM(i,j) = 0;
//				}
//			}
//
//			for (int k = 0; k < Np; k++)
//			{
//				for (int l = 0; l < Np; l++)
//				{
//					for (int x = 0; x < P; x++)
//					{
//						XM(x,(k-1)*Np+l) = XD(x,k)*std::conj((std::complex<double>) XD(x,l));
//					}
//				}
//			}

			/////////// Second FFT /////////////




		}
		
		/**
		 * fftshift equivalent
		 */
		void fftShift(float *inputFFT, float *outputFFT, double *outputFreqs, double centre, double bandwidth, int vector_length)
		{
			double samplewidth = bandwidth/(double)vector_length;
			for (unsigned int i = 0; i < vector_length; i++){
				/* FFT is arranged starting at 0 Hz at the start, rather than in the middle */
				if (i < vector_length/2){ //lower half of the fft
					outputFFT[i + vector_length/2] = inputFFT[i];
				}
				else { //upper half of the fft
					outputFFT[i - vector_length/2] = inputFFT[i];
				}

				outputFFT[i] = centre + i * samplewidth - bandwidth/2; //calculate the frequency of this sample
			}
		}
		
		
//		void ZeroBuffer(float* buffer)
//		{
//			/* writes zeros to m_buffer */
//			for (unsigned int i = 0; i < m_vector_length; i++){
//				m_buffer[i] = 0.0;
//			}
//		}
		
		// Our osmo source
		osmosdr_source_c_sptr m_source;

		// Not sure if I'll use
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
