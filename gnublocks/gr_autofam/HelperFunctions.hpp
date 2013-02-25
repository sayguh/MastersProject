

#include <vector>
#define _USE_MATH_DEFINES // for C++
#include <cmath>
/// Round up to next higher power of 2 (return x if it's already a power
/// of 2).
inline int pow2roundup (int x);
std::vector<float> GetWindow(size_t n);


// Taken from: http://stackoverflow.com/questions/364985/algorithm-for-finding-the-smallest-power-of-two-thats-greater-or-equal-to-a-giv
/**
 * Looks like this only works for 32 bit integers I think we should be safe though, not using it for anything HUGE.
 */
inline int pow2roundup (int x)
{
    if (x < 0)
        return 0;
    --x;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x+1;
}

/* http://en.wikipedia.org/w/index.php?title=Window_function&oldid=508445914 */
std::vector<float> hamming(size_t n)
{
	std::vector<float> w;
	w.resize(n);

	double a = 0.54;
	double b = 1-a;

	for (unsigned int i = 0; i < n; i++){
		w[i] = a - b * cos(2*M_PI*i/(n-1));
	}
	return w;
}
