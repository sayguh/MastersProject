function y = zeroShift(x,n)


if n == 0
  y = x;
  return
end

y = zeros(size(x));

if n > 0
  y(1:end-n) = x(1+n:end);
else
  n = -n;
  y(1+n:end) = x(1:end-n);
end



