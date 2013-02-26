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
#include <fftw3.h>

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
			gr_block ("autofam_sink", // The size increased by 2 since we take in complex.
				gr_make_io_signature (1, 1, 2*sizeof (float) * vector_length),
				gr_make_io_signature (0, 0, 0)),
			m_source(source), //We need the source in order to be able to control it
			m_vector_length(vector_length),
			m_fs(sampleRate),
			m_df(freqRes),
			m_dalpha(cycFreqRes),
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
			m_vector_length = 16;
			m_fs = 100;
			m_df = 24;
			m_dalpha = 12;
			ProcessVector((&testData[0]));


			// The real data
//			for (int i = 0; i < ninput_items[0]; i++){
//				ProcessVector(((float *)input_items[0]) + i * m_vector_length);
//			}

			consume_each(ninput_items[0]);
			printf("\nTest Over, completed\n");
			// Testing so exit after 1 iteration
			exit(-1);

			return 0;
		}
		
		void ProcessVector(float *input)
		{


			int Np(pow2roundup((int)std::ceil(m_fs/m_df)));
			int L(Np/4);
			int P(pow2roundup((int) std::ceil(m_fs/m_dalpha/L)));
			int N(P*L);
			int NN((P-1)*L + Np);
			fftw_complex *in, *out;
			fftw_plan fftPlan;

			printf("Np = %i\n", Np);
			printf("L = %i\n", L);
			printf("P = %i\n", P);
			printf("N = %i\n", N);
			printf("NN = %i\n", NN);

			MatrixXcd X(Np,P);
			for (int k = 0; k < P; k++)
			{
				for (int i = 0; i < Np; i++)
				{
					if (k*L + i < m_vector_length)
						X(i, k) = input[k*L + i];
					else
						X(i,k) = 0;
				}
			}

			std::cout << "Matrix X:\n" << X << std::endl;

			std::vector<float> window = hamming(Np);

			MatrixXcd hammingMatrix(Np, Np);

			for (int i = 0; i < Np; i++)
			{
				for (int j = 0; j < Np; j++)
				{
					if (i == j)
						hammingMatrix(i,j) = window[i];
					else
						hammingMatrix(i,j) = 0;
				}
			}

			MatrixXcd XW = hammingMatrix * X;

			std::cout << "Matrix XW:\n" << XW << std::endl;

			in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * Np);
			out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * Np);
			fftPlan = fftw_plan_dft_1d(Np, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

			MatrixXcd XF1(Np,P);

			for (int i = 0; i < P; i++)
			{
				for (int j = 0; j < Np; j++)
				{
					in[j][0] = ((std::complex<double>) XW(j,i)).real();	// Fill up the input FFT array
					in[j][1] = ((std::complex<double>) XW(j,i)).imag();	// Fill up the input FFT array
				}

				fftw_execute(fftPlan); // Execute the FFT

				// We FFT Shift each column as we read it out
				for (int j = 0; j < Np; j++)
				{
					if (j < Np/2)
						XF1(j+Np/2, i) = std::complex<double>(out[j][0],out[j][1]);
					else
						XF1(j-Np/2, i) = std::complex<double>(out[j][0],out[j][1]);
				}
			}
			// Clean up the FFT
			fftw_destroy_plan(fftPlan);
			fftw_free(in);
			fftw_free(out);

			std::cout << "Matrix XF1:\n" << XF1<< std::endl;

			MatrixXcd E(Np,P);

			for (int i = 0; i < Np; i++)
				for (int k = 0; k < P; k++)
					E(i,k) = 0;

			/*****************
			* Down conversion *
			******************/
			std::complex<double> i;
			i.imag(1);

			for (int k = -Np/2; k<Np/2; k++) {
				for (int m = 0; m<P; m++) {
					std::complex<double> x = -2*M_PI*k*m*L/Np;
					E(k+Np/2,m) = std::exp(x*i);
				}
			}

			std::cout << "Matrix E:\n" << E << std::endl;

			MatrixXcd XD(Np,P);

			// I do the multiply and transpose at the same time here.
			for (int i =0; i < Np; i++)
				for (int j = 0; j < P; j++)
					XD(j,i) = XF1(i,j) * E(i,j);

			std::cout << "Matrix XD':\n" << XD << std::endl;


			MatrixXcd XM(P,Np*Np);  // Our zero matrix

			for (int k = 0; k < Np; k++)
				for (int l = 0; l < Np; l++)
					for (int x = 0; x < P; x++)
					{
						std::complex<double> test = XD(x,l);
						XM(x,k*Np+l) = XD(x,k)*std::conj(test);
					}

			std::cout << "Matrix XM:\n" << XM << std::endl;
			/////////// Second FFT /////////////


			in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * P);
			out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * P);
			fftPlan = fftw_plan_dft_1d(P, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

			MatrixXcd XF2(P,Np*Np);

			for (int i = 0; i < Np*Np; i++)
			{
				for (int j = 0; j < P; j++)
				{
					in[j][0] = ((std::complex<double>) XM(j,i)).real();	// Fill up the input FFT array
					in[j][1] = ((std::complex<double>) XM(j,i)).imag();	// Fill up the input FFT array
				}

				fftw_execute(fftPlan); // Execute the FFT

				// We FFT Shift each column as we read it out
				for (int j = 0; j < P; j++)
				{
					if (j < P/2)
						XF2(j+P/2, i) = std::complex<double>(out[j][0],out[j][1]);
					else
						XF2(j-P/2, i) = std::complex<double>(out[j][0],out[j][1]);
				}
			}
			// Clean up the FFT
			fftw_destroy_plan(fftPlan);
			fftw_free(in);
			fftw_free(out);

			std::cout << "Matrix XF2:\n" << XF2 << std::endl;

			Eigen::MatrixXd M(P/2+1,Np*Np);

			for (int i = 0; i < P/2+1; i++)
				for (int j = 0; j < Np*Np; j++)
					M(i,j) = std::abs((std::complex<double>) XF2(i + P/4-1,j));

			std::cout << "Matrix M:\n" << M << std::endl;

			Eigen::VectorXd alpha0(2*N+1);
			alpha0(0) = -1;

			for (int i = 1; i < 2*N+1; i++)
				alpha0(i) = alpha0(i-1) + 1.0/N;

			std::cout << "Vector alpha0:\n" << alpha0 << std::endl;

			Eigen::VectorXd fo(Np+1);
			fo(0) = -0.5;

			for (int i = 1; i < Np+1; i++)
				fo(i) = fo(i-1) + 1.0/Np;

			std::cout << "Vector fo:\n" << fo<< std::endl;

			Eigen::MatrixXd Sx(Np+1,2*N+1);

			for (int i = 0; i < Np+1; i++)
				for (int j = 0; j < 2*N+1; j++)
					Sx(i,j) = 0;


			double l, k, p, alpha, f;
			int kk,ll;

			// Rather than try and figure out how to change the matlab code to a 0 start index, I'm just copying
			// it exactly and then putting "-1"'s in my matrix access.
			for (int k1 = 1; k1 < P/2 + 2; k1++)
			{
				for (int k2 = 1; k2 < Np*Np; k2++)
				{
					if (k2 % Np == 0)
						l = Np/2 - 1;
					else
						l = (k2 % Np) - Np/2 - 1;

					k = std::ceil((double)k2/ (double)Np) - Np/2 - 1;
					p = k1 - (double)P/4.0 - 1;
					alpha = ((k-l)/(double)Np) + (p-1)/((double) L)/((double)P);
					f = (k+l)/2.0/(double)Np;

					if (alpha < -1 || alpha > 1)
					{
						k2 = k2 + 1;
					}
					else if (f < -0.5 || f > 0.5)
					{
						k2 = k2 + 1;
					}
					else
					{
						kk = std::ceil(1 + Np*((double)f + 0.5));
						ll = 1 + N*(alpha + 1);
						Sx(kk-1,ll-1) = M(k1-1,k2-1);
					}
				}
			}

			std::cout << "Matrix Sx:\n" << Sx << std::endl;

		}
		
		// Our osmo source
		osmosdr_source_c_sptr m_source;

		// Not sure if I'll use
		int m_vector_length;

		double m_centerFreq;
		double m_fs; // sample rate
		double m_df; // desired frequency resolution
		double m_dalpha; // desired cyclic frequency resolution

		// Used for writing output to file
		std::string m_fileName;
		std::fstream filestr;

};

/* Shared pointer thing gnuradio is fond of */
typedef boost::shared_ptr<autofam_sink> autofam_sink_sptr;
autofam_sink_sptr make_autofam_sink(osmosdr_source_c_sptr source, unsigned int vector_length, double centerFreq, double sampleRate, double freqRes, double cycFreqRes, std::string fileName)
{
	return boost::shared_ptr<autofam_sink>(new autofam_sink(source, vector_length, centerFreq, sampleRate, freqRes, cycFreqRes, fileName));
}
