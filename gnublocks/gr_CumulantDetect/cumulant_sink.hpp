/*
	gr-cumulant - A GNU Radio spectral auto-correlation density function
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
class cumulant_sink : public gr_block
{
	// source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName)
	public:
		cumulant_sink(osmosdr_source_c_sptr source, int vector_length, std::string fileName) :
			gr_block ("cumulant_sink", // The size increased by 2 since we take in complex.
				gr_make_io_signature (1, 1, 2*sizeof (float) * vector_length),
				gr_make_io_signature (0, 0, 0)),
			m_source(source), //We need the source in order to be able to control it
			m_vector_length(vector_length),
		    m_fileName(fileName)
		{

		}

		virtual ~cumulant_sink()
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

			int modulation = -4;
			float minDistance;
			float N = m_vector_length;

			std::complex<float> C20 = 0;
			std::complex<float> C21 = 0;
			std::complex<float> C40 = 0;
			std::complex<float> C41 = 0;
			std::complex<float> C42 = 0;

			for(int i = 0; i < m_vector_length; ++i)
			{
				C20 += pow(input[i], 2);
				C21 += std::norm(input[i]);
			}
			C20 = 1/N * C20;
			C21 = 1/N * C21;

			for(int i = 0; i < m_vector_length; ++i)
			{
				C40 += pow(input[i], 4);
				C41 += pow(input[i], 3) * std::conj(input[i]);
			}
			std::complex<float> C20squared;
			C20squared = pow(C20,2);

			C40 = (1/N * C40) - std::complex<float>(3.0)*C20squared;
			C41 = (1/N * C41) - std::complex<float>(3.0)*C20*C21;

			for(int i = 0; i < m_vector_length; ++i)
				C42 += pow(std::abs(input[i]), 4);

			C42 = (1/N * C42) - (std::complex<float>)std::norm(C20) - std::complex<float>(2.0)*(pow(C21, 2));


			// Normalize
			C40 = C40/pow(C21, 2);
			C41 = C41/pow(C21, 2);
			C42 = C42/pow(C21, 2);

			// Test for AM
			minDistance = distance(std::abs(C40), std::real(C42), 0.040723, 0.040723);
			modulation = 1;

//			printf("Distance to  AM: %f\n", minDistance);

			// Test for SSB
			float tmpDist;
			tmpDist = distance(std::abs(C40), std::real(C42), 0.079237, 0);

//			printf("Distance to SSB: %f\n", tmpDist);

			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 2;
			}

			// Test for FM
			tmpDist = distance(std::abs(C40), std::real(C42), 0, -1);
//			printf("Distance to  FM: %f\n", tmpDist);
			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 3;
			}

			// Test for BPSK
			tmpDist = distance(std::abs(C40), std::real(C42), 2, -2);
//			printf("Distance toBPSK: %f\n", tmpDist);
			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 4;
			}

			// Test for QAM
			tmpDist = distance(std::abs(C40), std::real(C42), 1, -1);
//			printf("Distance to QAM: %f\n", tmpDist);
			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 5;
			}

			// Test for 16QAM
			tmpDist = distance(std::abs(C40), std::real(C42), 0.68, -0.68);
//			printf("Distance to16QAM: %f\n", tmpDist);
			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 6;
			}

			// Test for 64QAM
			tmpDist = distance(std::abs(C40), std::real(C42), 0.6191, -0.6191);
//			printf("Distance to64QAM: %f\n", tmpDist);
			if (minDistance > tmpDist)
			{
				minDistance = tmpDist;
				modulation = 7;
			}

			printf("C20 = %f, C21 = %f, C40 = %f, C41 = %f, C42 = %f, Modulation = %i\n", std::abs(C20), std::abs(C21),std::abs(C40), std::abs(C41), std::real(C42), modulation);

		}
		
		float distance(float x1, float y1, float x2, float y2)
		{
			return pow(x2 - x1, 2) + pow(y2 - y1, 2);
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
typedef boost::shared_ptr<cumulant_sink> cumulant_sink_sptr;
cumulant_sink_sptr make_cumulant_sink(osmosdr_source_c_sptr source, int vector_length, std::string fileName)
{
	return boost::shared_ptr<cumulant_sink>(new cumulant_sink(source, vector_length, fileName));
}
