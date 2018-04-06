clear;

a = input('a: '); if isempty(a) a = 0; end
b = input('b: '); if isempty(b) b = 0; end
c = input('c: '); if isempty(c) c = 0; end

disp(['> Solving ', num2str(a), 'x^2 + ', num2str(b), 'x + ', num2str(c), '...']);

if a != 0
  tosqrt = (b^2) - 4*a*c;
  if tosqrt >= 0
    root1 = (-b + sqrt(tosqrt)) / (2*a)
    root2 = (-b - sqrt(tosqrt)) / (2*a)
  else
    disp(['> No real roots']);
  endif
else
  disp('> a = 0, solving as linear equation');
  if b != 0
    root = (-c) / b
  else
    disp('> b is also = 0');
    root = c
  endif
endif
