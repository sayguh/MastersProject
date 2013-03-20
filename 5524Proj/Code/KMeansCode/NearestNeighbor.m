function [center index] = NearestNeighbor(point, centers)

N = length(centers);

for i = 1:N
	disSquared(i) = (real(centers(i)) - real(point))^2 + (imag(centers(i)) - imag(point))^2;
end

[minDis index] = min(disSquared);

center = centers(index);
