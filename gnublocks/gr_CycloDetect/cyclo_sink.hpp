/*
	gr-cyclo - A GNU Radio spectral auto-correlation density function
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
#include <fftw3.h>

#include <boost/shared_ptr.hpp>

#include <string>
#include <gr_block.h>
#include <gr_io_signature.h>
#include <osmosdr_source_c.h>

using Eigen::MatrixXcd;  // Using only complex double matrixes
class cyclo_sink : public gr_block
{
	// source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName)
	public:
		cyclo_sink(osmosdr_source_c_sptr source, int vector_length, std::string fileName) :
			gr_block ("cyclo_sink", // The size increased by 2 since we take in complex.
				gr_make_io_signature (1, 1, 2*sizeof (float) * vector_length),
				gr_make_io_signature (0, 0, 0)),
			m_source(source), //We need the source in order to be able to control it
			m_vector_length(vector_length),
		    m_fileName(fileName)
		{

		}

		virtual ~cyclo_sink()
		{
		}
		
	private:
		virtual int general_work(int noutput_items, gr_vector_int &ninput_items, gr_vector_const_void_star &input_items, gr_vector_void_star &output_items)
		{
			std::complex<float> input[m_vector_length];

			// Test Data
			for (int i = 0; i < m_vector_length; ++i)
			{
				float randNum = ((float) rand()) / ((float)RAND_MAX);
				input[i] = std::complex<float>(sin(randNum), cos(randNum));  // Random FM Signal
//				printf("input(%i) = %f, %f\n", i, std::real(input[i]), std::imag(input[i]));
			}

			ProcessVector(input);

//			// The real data
//			for (int i = 0; i < ninput_items[0]; i++)
//			{
//				ProcessVector(((std::complex<float> *)input_items[0]) + i * m_vector_length);
//			}

			consume_each(ninput_items[0]);
			return 0;
		}
		
		void ProcessVector(std::complex<float> *input)
		{

			// Replace this later
			int numPoints = 12800;
			int blockSize = 128;
			fftw_complex *in, *out;
			fftw_plan fftPlan;

			float N = m_vector_length;
			std::complex<float> maxValue = max(input, N);
			// Scale the incoming data
			for (int i = 0; i < N; ++i) {
				input[i] = input[i]/maxValue;
			}

			int numCols = numPoints / blockSize;


			MatrixXcd dataBlock(blockSize,numCols);
			MatrixXcd fftBlock(blockSize, numCols);
			MatrixXcd Sxa(blockSize, blockSize+1);

			// Zero matrix
			for (int i = 0; i < blockSize; ++i) {
				for (int j = 0; j < (blockSize+1); ++j) {
					Sxa(i,j) = 0;
				}
			}

			// Fill datablock
			for (int j = 0; j < numCols; ++j) {
				for (int i = 0; i < blockSize; ++i) {
					dataBlock(i,j) = input[blockSize*j + i];
				}
			}

			// Add the hamming window in here.
			//
			//
			//


			in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * blockSize);
			out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * blockSize);
			fftPlan = fftw_plan_dft_1d(blockSize, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

			for (int i = 0; i < P; i++)
			{
				for (int j = 0; j < Np; j++)
				{
					in[j][0] = ((std::complex<double>) dataBlock(j,i)).real();	// Fill up the input FFT array
					in[j][1] = ((std::complex<double>) dataBlock(j,i)).imag();	// Fill up the input FFT array
				}

				fftw_execute(fftPlan); // Execute the FFT

				// We FFT Shift each column as we read it out
				for (int j = 0; j < blockSize; j++)
				{
					if (j < Np/2)
						fftBlock(j+blockSize/2, i) = std::complex<double>(out[j][0],out[j][1]);
					else
						fftBlock(j-blockSize/2, i) = std::complex<double>(out[j][0],out[j][1]);
				}
			}
			// Clean up the FFT
			fftw_destroy_plan(fftPlan);
			fftw_free(in);
			fftw_free(out);




		}
		
		std::complex<float> max(std::complex<float> *input, int n)
		{
			std::complex<float> maxValue = 0;
			for (int i = 0; i < n; ++i) {
				if (std::abs(input[i]) > std::abs(maxValue)) {
					maxValue = input[i];
				}
			}
			return maxValue;
		}




		// Our osmo source
		osmosdr_source_c_sptr m_source;

		// Not sure if I'll use
		int m_vector_length;

		double m_centerFreq;

		// Used for writing output to file
		std::string m_fileName;
		std::fstream filestr;

};

/* Shared pointer thing gnuradio is fond of */
typedef boost::shared_ptr<cyclo_sink> cyclo_sink_sptr;
cyclo_sink_sptr make_cyclo_sink(osmosdr_source_c_sptr source, int vector_length, std::string fileName)
{
	return boost::shared_ptr<cyclo_sink>(new cyclo_sink(source, vector_length, fileName));
}
