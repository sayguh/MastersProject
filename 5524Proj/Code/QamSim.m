% The bulk of the code found below is taken from:  http://www.mathworks.com/matlabcentral/fileexchange/20569-16qam-ber-with-gray-mapping
% I (Youssef Bagoulla) have modified it to fit my needs for this project.


function sym = QamSim(NumSym, M, Es_N0_dB)

N = NumSym;
	
k = log2(M); % bits per symbol


if k == 1 % We're doing BPSK and treat that seperatly

	ipBit = rand(1,N*k,1)>0.5; % random 1's and 0's
	s = 2*ipBit-1; 

else

	% defining the real and imaginary PAM constellation
	% for 16-QAM
	alphaRe = [-(2*sqrt(M)/2-1):2:-1 1:2:2*sqrt(M)/2-1];
	alphaIm = [-(2*sqrt(M)/2-1):2:-1 1:2:2*sqrt(M)/2-1];
	normFactor = 1 / sqrt(2/3 * (M-1));

	% Mapping for binary <--> Gray code conversion
	ref = [0:k-1];
	map = bitxor(ref,floor(ref/2));
	[tt ind] = sort(map);                                
	    
	% symbol generation
	% ------------------
	ipBit = rand(1,N*k,1)>0.5; % random 1's and 0's
	ipBitReshape = reshape(ipBit,k,N).';
	bin2DecMatrix = ones(N,1)*(2.^[(k/2-1):-1:0]) ; % conversion from binary to decimal

	% real
	ipBitRe =  ipBitReshape(:,[1:k/2]);
	ipDecRe = sum(ipBitRe.*bin2DecMatrix,2);
	ipGrayDecRe = bitxor(ipDecRe,floor(ipDecRe/2));

	% imaginary
	ipBitIm =  ipBitReshape(:,[k/2+1:k]);
	ipDecIm = sum(ipBitIm.*bin2DecMatrix,2);
	ipGrayDecIm = bitxor(ipDecIm,floor(ipDecIm/2)); 

	% mapping the Gray coded symbols into constellation
	modRe = alphaRe(ipGrayDecRe+1);
	modIm = alphaIm(ipGrayDecIm+1);

	% complex constellation
	mod = modRe + j*modIm;
	%s = k_16QAM*mod; % normalization of transmit power to one
	s = normFactor*mod; % normalization of average transmit power to one  
end

if Es_N0_dB != 'IDEAL'
	%Es_N0_dB  = Eb_N0_dB + 10*log10(k);

	% noise
	% -----
	n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white guassian noise, 0dB variance 
	scaledNoise = 10^(-Es_N0_dB/20)*n; % additive white gaussian noise

	sym = s + scaledNoise;

else
	sym = s;
	scaledNoise = 0*sym;
end

